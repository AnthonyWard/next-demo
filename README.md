# Next.js + Storybook Setup Guide

This repository contains a comprehensive tutorial and setup scripts for creating a new Next.js application with Storybook integration and testing.

## Files Included

### 📖 TUTORIAL.md
A detailed step-by-step tutorial covering:
- Creating a new Next.js app with `pnpm`
- Installing and configuring Storybook
- Setting up testing with Vitest and React Testing Library
- Creating a sample Button component with stories and tests
- Running tests and validation

**For manual setup, follow this guide.**

### 🚀 auto-setup.sh
An automated setup script that performs all tutorial steps in one command.

**Usage:**
```bash
chmod +x auto-setup.sh
./auto-setup.sh
```

**What it does:**
- Creates a new Next.js project
- Installs and configures Storybook
- Creates example Button component with story
- Sets up testing framework and dependencies
- Creates test files and configurations
- Runs initial tests to verify setup

### ✅ validate-setup.sh
A validation script to check if your setup is complete and correct.

**Usage:**
```bash
chmod +x validate-setup.sh
./validate-setup.sh
```

**What it checks:**
- Prerequisites (Node.js, pnpm)
- Next.js configuration and structure
- Storybook installation and configuration
- Component files and story files
- Testing setup (Vitest, React Testing Library)
- Required npm scripts
- Provides summary of what's missing (if anything)

## Quick Start Options

### Option 1: Automated Setup (Recommended)
```bash
./auto-setup.sh
```
This will create everything automatically. Follow the prompts.

### Option 2: Manual Setup (Learning Path)
Follow the detailed instructions in [TUTORIAL.md](./TUTORIAL.md).

### Option 3: Validate Existing Setup
If you've already completed the setup, verify it with:
```bash
./validate-setup.sh
```

## Project Structure

After setup, your project will have this structure:

```
my-app/
├── .storybook/
│   ├── main.ts
│   └── preview.ts
├── src/
│   ├── app/
│   ├── components/
│   │   ├── Button.tsx
│   │   ├── Button.stories.tsx
│   │   └── Button.test.tsx
│   ├── test/
│   │   └── setup.ts
│   └── ...
├── vitest.config.ts
├── next.config.ts
├── package.json
└── tsconfig.json
```

## Available Commands

Once setup is complete, run these commands from your project directory:

```bash
# Development
pnpm dev              # Start Next.js development server

# Storybook
pnpm storybook        # Start Storybook on http://localhost:6006
pnpm build-storybook  # Build Storybook for production

# Testing
pnpm test             # Run tests with Vitest
pnpm test:watch       # Run tests in watch mode
pnpm test:ui          # Run tests with UI
pnpm test:coverage    # Generate coverage report

# Production
pnpm build            # Build Next.js app
pnpm start            # Start production server

# Linting
pnpm lint             # Run ESLint
```

## Technology Stack

- **Next.js 14+**: React framework with App Router
- **TypeScript**: Static type checking
- **Tailwind CSS**: Utility-first CSS framework
- **Storybook 7+**: Component development environment
- **Vitest**: Fast unit test framework
- **React Testing Library**: Component testing utilities
- **ESLint**: Code quality tool

## Prerequisites

- **Node.js** 18.17 or later
- **pnpm** 8 or later (install with `npm install -g pnpm`)

## Troubleshooting

### pnpm not found
Install globally:
```bash
npm install -g pnpm
pnpm --version
```

### Script not executable
Make scripts executable:
```bash
chmod +x auto-setup.sh
chmod +x validate-setup.sh
```

### Storybook won't start
Clear and reinstall:
```bash
rm -rf node_modules .pnpm-lock.yaml
pnpm install
pnpm storybook
```

### Tests fail
Ensure test setup file exists and dependencies are installed:
```bash
pnpm install
pnpm list vitest @testing-library/react
```

## Next Steps

After completing setup:

1. **Explore Storybook**: Run `pnpm storybook` and browse the example stories
2. **Review Components**: Check `src/components/Button.*` files
3. **Run Tests**: Execute `pnpm test` to see the test suite
4. **Create More Components**: Add new components following the Button pattern
5. **Configure CI/CD**: Set up GitHub Actions or your preferred CI tool

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Storybook for React](https://storybook.js.org/docs/react)
- [Vitest Documentation](https://vitest.dev/)
- [React Testing Library](https://testing-library.com/docs/react-testing-library/intro/)
- [pnpm Documentation](https://pnpm.io/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

## Support

For issues or questions:
1. Check the [TUTORIAL.md](./TUTORIAL.md) Troubleshooting section
2. Review the official documentation links above
3. Run `./validate-setup.sh` to check your setup
4. Check the official GitHub repositories for the tools used

---

**Happy coding! 🚀**
