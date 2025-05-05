# SmartMerge: Intelligent Git Branch Merging Utility

## Overview

SmartMerge is a Git utility that simplifies branch merging by automatically choosing the right merge strategy based on branch relationship. It performs fast-forward merges when possible and clean squash merges when branches have diverged, maintaining a tidy commit history. SmartMerge intelligently preserves your working changes and returns you to your original branch after the merge.

## Getting Started

No installation is needed. You should have the following files in your project:
- `smartmerge.sh`: The main script containing the smartmerge function
- `tests/complex_merge_tests.sh`: Tests for complex merge scenarios
- `tests/unified_test_suite.sh`: Unified test suite runner

## Usage

### Loading the SmartMerge Function

First, source the script to make the `smartmerge` function available in your shell:

```bash
source ./smartmerge.sh
```

### Basic Usage

The basic syntax for using smartmerge is:

```bash
smartmerge <source-branch> <target-branch>
```

Where:
- `<source-branch>`: The branch containing changes you want to merge (typically a feature branch)
- `<target-branch>`: The branch you want to merge into (typically main/master)

Example:
```bash
smartmerge feature-123 main
```

### Debug Mode

To see detailed information about the merge process, use the `--debug` flag:

```bash
smartmerge --debug feature-123 main
```

This will show:
- Pre-merge commit state of both branches
- Type of merge being performed (fast-forward or squash)
- List of commits being combined (for squash merges)
- Post-merge commit state

## How It Works

SmartMerge performs the following actions:

1. Validates that both branches exist
2. Saves your current work with `git stash` (if necessary)
3. Checks out the target branch
4. Determines the optimal merge strategy:
   - If target is an ancestor of source: performs a clean fast-forward merge
   - Otherwise: performs a squash merge with references to the original commits
5. Restores your stashed changes (if any were stashed)
6. Returns to your original branch

## Examples

### Example 1: Merging a Feature Branch into Main

```bash
# While on any branch
smartmerge feature-auth main
```

This will merge all commits from `feature-auth` into `main` as a single squash commit (if branches have diverged) or as a fast-forward (if possible).

### Example 2: Using Debug Mode

```bash
smartmerge --debug hotfix-login master
```

This will show detailed information about the merge process, which is helpful for understanding what's happening or troubleshooting.

## Running Tests

SmartMerge comes with a test suite to verify its functionality:

```bash
# Run the unified test suite
bash tests/unified_test_suite.sh
```

This will run various tests including:
- Fast-forward merge tests
- Conflict resolution tests
- Squash merge tests
- Complex sequential merge tests
- Complex diverged branch tests

## Notes

- Your original branch commits remain intact - SmartMerge doesn't delete any commits
- SmartMerge automatically resolves most simple merge situations
- For complex merge conflicts, you'll need to resolve them manually and follow the on-screen instructions
- Always ensure your work is committed or stashed before running SmartMerge
- SmartMerge preserves your working directory state by automatically stashing and restoring changes

## When to Use SmartMerge

SmartMerge is ideal for:
- Keeping a clean, linear commit history
- Avoiding merge commit "bubbles" in your Git graph
- Maintaining meaningful commit messages that reference original work
- Simplifying the merge process for team members with varying Git experience levels
