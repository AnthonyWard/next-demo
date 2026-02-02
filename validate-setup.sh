#!/bin/bash

# Validation script for Next.js + Storybook setup tutorial
# This script checks if all required setup steps have been completed correctly

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

echo "================================"
echo "Next.js + Storybook Setup Validator"
echo "================================"
echo ""

# Helper function to check if a file exists
check_file() {
  local file=$1
  local description=$2
  
  if [ -f "$file" ]; then
    echo -e "${GREEN}✓${NC} $description"
    ((PASSED++))
    return 0
  else
    echo -e "${RED}✗${NC} $description (missing: $file)"
    ((FAILED++))
    return 1
  fi
}

# Helper function to check if a directory exists
check_dir() {
  local dir=$1
  local description=$2
  
  if [ -d "$dir" ]; then
    echo -e "${GREEN}✓${NC} $description"
    ((PASSED++))
    return 0
  else
    echo -e "${RED}✗${NC} $description (missing: $dir)"
    ((FAILED++))
    return 1
  fi
}

# Helper function to check if a command exists
check_command() {
  local cmd=$1
  local description=$2
  
  if command -v "$cmd" &> /dev/null; then
    echo -e "${GREEN}✓${NC} $description"
    ((PASSED++))
    return 0
  else
    echo -e "${RED}✗${NC} $description"
    ((FAILED++))
    return 1
  fi
}

# Helper function to check if a package is installed
check_package() {
  local package=$1
  local description=$2
  
  if grep -q "\"$package\"" package.json; then
    echo -e "${GREEN}✓${NC} $description"
    ((PASSED++))
    return 0
  else
    echo -e "${RED}✗${NC} $description"
    ((FAILED++))
    return 1
  fi
}

# Check prerequisites
echo -e "${YELLOW}Checking Prerequisites...${NC}"
check_command "node" "Node.js installed"
check_command "pnpm" "pnpm installed"
echo ""

# Check if in a Next.js project
echo -e "${YELLOW}Checking Next.js Setup...${NC}"
check_file "package.json" "package.json exists"
check_file "next.config.ts" "Next.js configuration (next.config.ts)"
check_file "tsconfig.json" "TypeScript configuration"
check_dir "src" "src/ directory exists"
check_dir "public" "public/ directory exists"
echo ""

# Check Storybook installation
echo -e "${YELLOW}Checking Storybook Setup...${NC}"
check_dir ".storybook" ".storybook/ configuration directory"
check_file ".storybook/main.ts" "Storybook main configuration"
check_file ".storybook/preview.ts" "Storybook preview configuration"
check_package "storybook" "Storybook package installed"
check_package "@storybook/react" "@storybook/react package installed"
check_package "@storybook/nextjs" "@storybook/nextjs package installed"
echo ""

# Check component and story files
echo -e "${YELLOW}Checking Components and Stories...${NC}"
check_dir "src/components" "src/components/ directory exists"
check_file "src/components/Button.tsx" "Button component (Button.tsx)"
check_file "src/components/Button.stories.tsx" "Button component story (Button.stories.tsx)"
echo ""

# Check test setup
echo -e "${YELLOW}Checking Test Setup...${NC}"
check_file "vitest.config.ts" "Vitest configuration"
check_file "src/test/setup.ts" "Test setup file"
check_file "src/components/Button.test.tsx" "Button component test"
check_package "vitest" "Vitest package installed"
check_package "@testing-library/react" "@testing-library/react package installed"
check_package "@testing-library/jest-dom" "@testing-library/jest-dom package installed"
check_package "@testing-library/user-event" "@testing-library/user-event package installed"
echo ""

# Check package.json scripts
echo -e "${YELLOW}Checking package.json Scripts...${NC}"
if grep -q '"dev"' package.json && grep -q '"build"' package.json; then
  echo -e "${GREEN}✓${NC} Standard Next.js scripts defined"
  ((PASSED++))
else
  echo -e "${RED}✗${NC} Standard Next.js scripts missing"
  ((FAILED++))
fi

if grep -q '"storybook"' package.json; then
  echo -e "${GREEN}✓${NC} Storybook start script defined"
  ((PASSED++))
else
  echo -e "${RED}✗${NC} Storybook start script missing"
  ((FAILED++))
fi

if grep -q '"test"' package.json; then
  echo -e "${GREEN}✓${NC} Test script defined"
  ((PASSED++))
else
  echo -e "${RED}✗${NC} Test script missing"
  ((FAILED++))
fi
echo ""

# Summary
echo "================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo "================================"
echo ""

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}✓ All checks passed! Your setup is complete.${NC}"
  echo ""
  echo "You can now run:"
  echo "  - pnpm dev          (Start Next.js development server)"
  echo "  - pnpm storybook    (Start Storybook)"
  echo "  - pnpm test         (Run tests)"
  echo ""
  exit 0
else
  echo -e "${RED}✗ Some checks failed. Please review the items above.${NC}"
  echo ""
  echo "To complete the setup, follow the TUTORIAL.md file."
  echo ""
  exit 1
fi
