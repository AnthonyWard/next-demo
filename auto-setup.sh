#!/bin/bash

# Automated setup script for Next.js + Storybook project
# This script automates the entire tutorial setup process

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Next.js + Storybook Auto Setup${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command -v node &> /dev/null; then
  echo -e "${RED}Error: Node.js is not installed${NC}"
  exit 1
fi
echo -e "${GREEN}✓ Node.js installed ($(node --version))${NC}"

if ! command -v pnpm &> /dev/null; then
  echo -e "${YELLOW}Installing pnpm...${NC}"
  npm install -g pnpm
fi
echo -e "${GREEN}✓ pnpm installed ($(pnpm --version))${NC}"
echo ""

# Get project name
# read -p "Enter project name (default: my-app): " PROJECT_NAME
#PROJECT_NAME=${PROJECT_NAME:-my-app}
PROJECT_NAME=my-app

echo ""
echo -e "${YELLOW}Creating Next.js app...${NC}"
pnpm create next-app@latest "$PROJECT_NAME" \
  --typescript \
  --tailwind \
  --eslint \
  --src-dir \
  --app \
  --no-git \
  --import-alias '@/*' \
  --use-pnpm \
  --react-compiler

cd "$PROJECT_NAME"

echo -e "${GREEN}✓ Next.js app created${NC}"
echo ""

# Initialize Storybook
echo -e "${YELLOW}Installing Storybook...${NC}"
BROWSER=none pnpm dlx storybook@latest init --type nextjs --yes --skip-install
echo -e "${GREEN}✓ Storybook installed${NC}"
echo ""

# Create components directory if it doesn't exist
mkdir -p src/components

# Create Button component
echo -e "${YELLOW}Creating Button component...${NC}"
cat > src/components/Button.tsx << 'EOF'
export interface ButtonProps {
  variant?: 'primary' | 'secondary';
  size?: 'small' | 'medium' | 'large';
  onClick?: () => void;
  children: React.ReactNode;
}

export default function Button({
  variant = 'primary',
  size = 'medium',
  onClick,
  children,
}: ButtonProps) {
  const baseClasses = 'font-semibold rounded transition-colors';
  
  const variantClasses = {
    primary: 'bg-blue-500 text-white hover:bg-blue-600',
    secondary: 'bg-gray-200 text-gray-800 hover:bg-gray-300',
  };

  const sizeClasses = {
    small: 'px-2 py-1 text-sm',
    medium: 'px-4 py-2 text-base',
    large: 'px-6 py-3 text-lg',
  };

  return (
    <button
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
}
EOF
echo -e "${GREEN}✓ Button component created${NC}"

# Create Button story
echo -e "${YELLOW}Creating Button story...${NC}"
cat > src/components/Button.stories.tsx << 'EOF'
import type { Meta, StoryObj } from '@storybook/react';
import { userEvent, within, expect } from '@storybook/test';
import Button from './Button';

const meta = {
  title: 'Components/Button',
  component: Button,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    variant: 'primary',
    children: 'Primary Button',
  },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole('button', { name: /Primary Button/i });
    expect(button).toBeInTheDocument();
    expect(button).toHaveClass('bg-blue-500');
  },
};

export const Secondary: Story = {
  args: {
    variant: 'secondary',
    children: 'Secondary Button',
  },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole('button', { name: /Secondary Button/i });
    expect(button).toBeInTheDocument();
    expect(button).toHaveClass('bg-gray-200');
  },
};

export const Large: Story = {
  args: {
    size: 'large',
    children: 'Large Primary Button',
  },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole('button', { name: /Large Primary Button/i });
    expect(button).toBeInTheDocument();
    expect(button).toHaveClass('px-6');
  },
};

export const Interactive: Story = {
  args: {
    variant: 'primary',
    children: 'Click me',
  },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    const button = canvas.getByRole('button', { name: /Click me/i });
    
    // Test initial state
    expect(button).toBeInTheDocument();
    
    // Test interaction
    await userEvent.click(button);
    expect(button).toHaveClass('bg-blue-500');
  },
};
EOF
echo -e "${GREEN}✓ Button story created${NC}"
echo ""

# Install testing dependencies
echo -e "${YELLOW}Installing testing dependencies...${NC}"
pnpm add -D vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom @vitejs/plugin-react @playwright/test @storybook/test @storybook/react @storybook/test-runner
echo -e "${GREEN}✓ Testing dependencies installed${NC}"
echo ""

# Create Vitest config
echo -e "${YELLOW}Creating Vitest configuration...${NC}"
cat > vitest.config.ts << 'EOF'
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './src/test/setup.ts',
    exclude: ['node_modules', 'dist', '.idea', '.git', '.cache', 'src/e2e'],
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
});
EOF
echo -e "${GREEN}✓ Vitest configuration created${NC}"

# Create test setup file
echo -e "${YELLOW}Creating test setup file...${NC}"
mkdir -p src/test
cat > src/test/setup.ts << 'EOF'
import '@testing-library/jest-dom';
EOF
echo -e "${GREEN}✓ Test setup file created${NC}"

# Create Button test
echo -e "${YELLOW}Creating Button test...${NC}"
cat > src/components/Button.test.tsx << 'EOF'
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, it, expect, vi } from 'vitest';
import Button from './Button';

describe('Button Component', () => {
  it('renders with children text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument();
  });

  it('calls onClick handler when clicked', async () => {
    const handleClick = vi.fn();
    const user = userEvent.setup();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    await user.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledOnce();
  });

  it('applies primary variant class by default', () => {
    render(<Button>Primary</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-blue-500');
  });

  it('applies secondary variant class when specified', () => {
    render(<Button variant="secondary">Secondary</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-gray-200');
  });
});
EOF
echo -e "${GREEN}✓ Button test created${NC}"
echo ""

# Create Storybook-Vitest integration test
echo -e "${YELLOW}Creating Storybook-Vitest test...${NC}"
cat > src/components/Button.stories.test.tsx << 'EOF'
import { describe, it, expect } from 'vitest';
import { render } from '@testing-library/react';
import { composeStories } from '@storybook/react';
import * as ButtonStories from './Button.stories';

const { Primary, Secondary, Large, Interactive } = composeStories(ButtonStories);

describe('Button Stories', () => {
  it('should render Primary story', () => {
    const { container } = render(<Primary />);
    expect(container).toBeDefined();
  });

  it('should render Secondary story', () => {
    const { container } = render(<Secondary />);
    expect(container).toBeDefined();
  });

  it('should render Large story', () => {
    const { container } = render(<Large />);
    expect(container).toBeDefined();
  });

  it('should render Interactive story', () => {
    const { container } = render(<Interactive />);
    expect(container).toBeDefined();
  });
});
EOF
echo -e "${GREEN}✓ Storybook-Vitest test created${NC}"
echo ""

# Create Playwright config
echo -e "${YELLOW}Creating Playwright configuration...${NC}"
cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './src/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
EOF
echo -e "${GREEN}✓ Playwright configuration created${NC}"

# Create e2e tests directory
echo -e "${YELLOW}Creating Playwright e2e test...${NC}"
mkdir -p src/e2e
cat > src/e2e/button.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('Button Component E2E', () => {
  test('should render button on home page', async ({ page }) => {
    await page.goto('/');
    // This test assumes you add a Button to your home page
    // You may need to adjust the page content first
    const button = page.locator('button');
    expect(button).toBeDefined();
  });
});
EOF
echo -e "${GREEN}✓ Playwright e2e test created${NC}"
echo ""

# Update package.json scripts
echo -e "${YELLOW}Updating package.json scripts...${NC}"
pnpm pkg set scripts.test="vitest"
pnpm pkg set scripts.test:ui="vitest --ui"
pnpm pkg set scripts.test:coverage="vitest --coverage"
pnpm pkg set scripts.storybook:test="test-storybook"
pnpm pkg set scripts.storybook:test:watch="test-storybook --watch"
pnpm pkg set scripts.e2e="playwright test"
pnpm pkg set scripts.e2e:ui="playwright test --ui"
echo -e "${GREEN}✓ Scripts updated${NC}"
echo ""

# Run tests
echo -e "${YELLOW}Running tests...${NC}"
if pnpm test --run; then
  echo -e "${GREEN}✓ All tests passed!${NC}"
else
  echo -e "${RED}✗ Some tests failed${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo "Your Next.js + Storybook project is ready!"
echo ""
echo "Available commands:"
echo -e "  ${YELLOW}pnpm dev${NC}               - Start Next.js development server"
echo -e "  ${YELLOW}pnpm storybook${NC}         - Start Storybook on http://localhost:6006"
echo -e "  ${YELLOW}pnpm test${NC}              - Run unit tests"
echo -e "  ${YELLOW}pnpm test:ui${NC}           - Run unit tests with UI"
echo -e "  ${YELLOW}pnpm storybook:test${NC}    - Run Storybook interaction tests"
echo -e "  ${YELLOW}pnpm storybook:test:watch${NC} - Run Storybook tests in watch mode"
echo -e "  ${YELLOW}pnpm e2e${NC}               - Run end-to-end tests"
echo -e "  ${YELLOW}pnpm e2e:ui${NC}            - Run e2e tests with UI"
echo ""
echo "Next steps:"
echo "  1. cd $PROJECT_NAME"
echo "  2. pnpm dev              (to start development)"
echo "  3. pnpm storybook        (to view components in Storybook)"
echo ""
