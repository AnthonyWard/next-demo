# Next.js + Storybook Setup Tutorial

This tutorial guides you through creating a new Next.js application with Storybook integration and testing setup using `pnpm`.

## Prerequisites

- **Node.js**: Version 18.17 or later
- **pnpm**: Version 8 or later (install with `npm install -g pnpm` if needed)

## Step 1: Create a New Next.js App

Run the following command to create a new Next.js application:

```bash
pnpm create next-app@latest my-app --typescript --tailwind --eslint
```

When prompted, answer the questions as follows:
- **Would you like to use TypeScript?** Yes (--typescript is set)
- **Would you like to use ESLint?** Yes (--eslint is set)
- **Would you like to use Tailwind CSS?** Yes (--tailwind is set)
- **Would you like your code inside a `src/` directory?** Yes (recommended)
- **Would you like to use App Router?** Yes (recommended)
- **Would you like to use Turbopack for next dev?** No (optional, skip for now)
- **Would you like to customize the import alias?** No (use defaults)

Navigate to your project directory:

```bash
cd my-app
```

Verify the installation was successful:

```bash
pnpm --version
pnpm list next
```

## Step 2: Install Storybook

Initialize Storybook in your Next.js project:

```bash
pnpm dlx storybook@latest init --type next
```

This command will:
- Detect that you're using Next.js and React
- Install Storybook dependencies
- Configure Storybook for Next.js
- Create example stories in `src/stories/`

The installation may ask if you'd like to add GitHub Actions. Choose based on your preference.

Verify Storybook files were created:

```bash
ls -la .storybook/
ls -la src/stories/
```

## Step 3: Run Storybook

Start the Storybook development server:

```bash
pnpm storybook
```

This will:
- Compile your Storybook
- Open Storybook in your default browser at `http://localhost:6006`
- Display example component stories

You should see the Storybook UI with example stories like Button and Header.

## Step 4: Create Your First Component with a Story

Create a simple Button component:

**File: `src/components/Button.tsx`**

```typescript
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
```

Create a story for the Button component:

**File: `src/components/Button.stories.tsx`**

```typescript
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
```

The `play` function in each story runs automatically in Storybook and allows you to test component behavior and user interactions directly within Storybook's UI.

## Step 5: Set Up Testing with Vitest and React Testing Library

Install testing dependencies:

```bash
pnpm add -D vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event jsdom @vitejs/plugin-react @playwright/test @storybook/test @storybook/react @storybook/test-runner
```

Create a Vitest configuration file:

**File: `vitest.config.ts`**

```typescript
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
```

Install the required Vite plugin:

```bash
pnpm add -D @vitejs/plugin-react
```

Create a test setup file:

**File: `src/test/setup.ts`**

```typescript
import '@testing-library/jest-dom';
```

Create a test for the Button component:

**File: `src/components/Button.test.tsx`**

```typescript
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
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
```

Install user-event for better user interaction testing:

```bash
pnpm add -D @testing-library/user-event @storybook/test
```

## Step 5b: Set Up Storybook Component Tests with Vitest

Create a Storybook-Vitest integration test file that uses `composeStories` to run your stories through Vitest:

**File: `src/components/Button.stories.test.tsx`**

```typescript
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
```

This approach allows you to test all your stories using Vitest, ensuring your component states render correctly.

## Step 6: Run Tests

Execute your tests with:

```bash
pnpm test
```

To run tests in watch mode:

```bash
pnpm test --watch
```

To run tests with coverage:

```bash
pnpm test --coverage
```

## Step 7: Set Up End-to-End Testing with Playwright

Install Playwright and its dependencies:

```bash
pnpm add -D @playwright/test
```

Create a Playwright configuration file:

**File: `playwright.config.ts`**

```typescript
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
```

Create an e2e test directory and add a test for the Button component:

**File: `src/e2e/button.spec.ts`**

```typescript
import { test, expect } from '@playwright/test';

test.describe('Button Component E2E', () => {
  test('should render button on home page', async ({ page }) => {
    await page.goto('/');
    const button = page.locator('button');
    expect(button).toBeDefined();
  });

  test('should interact with button', async ({ page }) => {
    await page.goto('/');
    const button = page.locator('button').first();
    await button.click();
    // Add more assertions based on your button's behavior
  });
});
```

Run your e2e tests:

```bash
pnpm e2e
```

To run tests with the UI:

```bash
pnpm e2e:ui
```

## Step 8: Update package.json Scripts

Ensure your `package.json` includes these scripts:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "storybook": "storybook dev -p 6006",
    "build-storybook": "storybook build",
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest --coverage",
    "storybook:test": "test-storybook",
    "storybook:test:watch": "test-storybook --watch",
    "e2e": "playwright test",
    "e2e:ui": "playwright test --ui"
  }
}
```

### Testing Your Components

You now have multiple ways to test your components:

**Unit & Story Tests:**
```bash
pnpm test                    # Run Vitest unit tests
pnpm test:ui                 # View results in UI
pnpm storybook:test          # Run Storybook interaction tests (requires Storybook running)
pnpm storybook:test:watch    # Watch mode for Storybook tests (requires Storybook running)
```

**E2E Tests:**
```bash
pnpm e2e                     # Run Playwright e2e tests
pnpm e2e:ui                  # View results in UI
```

**Visual Development:**
```bash
pnpm storybook               # Start Storybook dev server
```

**Running Storybook Tests:**

To run Storybook interaction tests, you need Storybook running in one terminal:

Terminal 1:
```bash
pnpm storybook
```

Terminal 2 (once Storybook is running):
```bash
pnpm storybook:test
```

The test runner will:
- Connect to your running Storybook instance
- Execute all play functions in your stories
- Report results and any failures

## Verification Checklist

After completing all steps, verify:

- [ ] Next.js app created successfully
- [ ] `pnpm dev` starts the development server
- [ ] Storybook starts with `pnpm storybook`
- [ ] Button component stories display correctly
- [ ] `pnpm test` runs and passes all tests
- [ ] `pnpm e2e` runs end-to-end tests successfully
- [ ] Components directory exists with Button component
- [ ] Test files exist and pass
- [ ] E2E test directory and files exist

## Running the Validation Script

A validation script is provided to check if all setup steps are complete. Run it from your project root:

```bash
./validate-setup.sh
```

## Troubleshooting

**Issue: `pnpm: command not found`**
- Install pnpm globally: `npm install -g pnpm`

**Issue: Storybook doesn't start**
- Delete `node_modules` and `.pnpm-lock.yaml`: `rm -rf node_modules .pnpm-lock.yaml`
- Reinstall: `pnpm install`
- Run `pnpm storybook` again

**Issue: Tests fail with module errors**
- Ensure `vitest.config.ts` is in the root directory
- Verify all test dependencies are installed: `pnpm list @testing-library/react vitest`

**Issue: TypeScript errors in test files**
- Add `vi` to global imports in `vitest.config.ts` by enabling `globals: true`
- Or add `import { vi } from 'vitest'` at the top of test files

## Next Steps

- Explore [Storybook documentation](https://storybook.js.org/docs/react)
- Learn about [Vitest](https://vitest.dev/)
- Read [React Testing Library best practices](https://testing-library.com/docs/react-testing-library/intro/)
- Set up continuous integration with GitHub Actions

## Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Storybook for Next.js](https://storybook.js.org/docs/react/get-started/install)
- [pnpm Documentation](https://pnpm.io/motivation)
