#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

test_complex_smartmerge_sequential() {
  echo "🔄 === TEST 1: SEQUENTIAL MERGE (EXPECT 4 COMMITS) ==="
  local test_dir=$(mktemp -d)
  echo "📁 Created test directory: $test_dir"
  cd "$test_dir" || return 1

  # Setup repo with 3 initial commits
  echo "🔧 Setting up Git repository..."
  git init >/dev/null
  git config --local user.name "Test"
  git config --local user.email "test@example.com"
  
  echo "🌟 Creating initial commits on main branch..."
  for i in {1..3}; do
    echo "main-$i" >file$i
    git add file$i
    git commit -m "Main commit $i" >/dev/null
    echo "✅ Created main commit $i"
  done
  
  # Force branch to be called main
  git branch -M main
  echo "✅ Set default branch to main"

  # Create feature branch with 5 commits
  echo "🌿 Creating feature branch with 5 commits..."
  git checkout -b feature >/dev/null
  for i in {1..5}; do
    echo "feature-$i" >feature$i
    git add feature$i
    git commit -m "Feature commit $i" >/dev/null
    echo "✅ Created feature commit $i"
  done

  # Debug: Show current state
  echo "🔍 Debug - Current branches:"
  git branch -a
  echo "🔍 Debug - Current branch: $(git branch --show-current)"
  echo "🔍 Debug - Main branch exists: $(git show-ref --verify --quiet refs/heads/main && echo 'YES' || echo 'NO')"
  echo "🔍 Debug - Feature branch exists: $(git show-ref --verify --quiet refs/heads/feature && echo 'YES' || echo 'NO')"

  # Load smartmerge function
  echo "⚡ Loading smartmerge function..."
  source ../../smartmerge.sh

  # Go back to main and merge
  echo "🔄 Switching to main branch..."
  git checkout main >/dev/null || {
    echo "❌ ERROR: Failed to checkout main branch"
    echo "🔍 Available branches:"
    git branch -a
    cd - >/dev/null && rm -rf "$test_dir"
    return 1
  }

  echo "🔀 Performing sequential merge..."
  if smartmerge --debug feature main; then
    echo "✅ Merge command executed successfully"
  else
    echo "❌ ERROR: Merge command failed"
    echo "🔍 Debug - Current branch: $(git branch --show-current)"
    echo "🔍 Debug - Git status:"
    git status
  fi

  # Verify commit count
  echo "📊 Counting commits..."
  local commit_count
  if commit_count=$(git rev-list --count main 2>/dev/null); then
    echo "📊 Final commit count: $commit_count"
    if [ "$commit_count" -eq 4 ]; then
      echo "✅ PASSED: Found $commit_count commits (3 main + 1 squash)"
    else
      echo "❌ FAILED: Expected 4 commits, got $commit_count"
      echo "🔍 Debug - Commit log:"
      git log --oneline main
    fi
  else
    echo "❌ ERROR: Failed to count commits"
    echo "🔍 Debug - Git log output:"
    git log --oneline 2>&1 || echo "Git log failed"
  fi

  cd - >/dev/null && rm -rf "$test_dir"
  echo "🧹 Cleaned up test directory"
  echo
}