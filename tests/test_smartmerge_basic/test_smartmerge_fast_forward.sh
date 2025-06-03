#!/usr/bin/env bash
test_smartmerge_fast_forward() {
  echo "🚀 === TEST: FAST FORWARD MERGE ==="
  local test_dir=$(mktemp -d)
  echo "📁 Created test directory: $test_dir"
  cd "$test_dir" || return 1

  # Setup repo
  echo "🔧 Setting up Git repository..."
  git init >/dev/null
  git config --local user.name "Test"
  git config --local user.email "test@example.com"
  
  # Create main branch (force it to be called main)
  echo "🌟 Creating main branch..."
  echo "initial" > initial.txt
  git add initial.txt
  git commit -m "Initial commit" >/dev/null
  git branch -M main
  echo "✅ Main branch created and set as default"

  # Create feature branch
  echo "🌿 Creating feature branch..."
  git checkout -b feature >/dev/null
  echo "feature-content" > feature.txt
  git add feature.txt
  git commit -m "Feature commit" >/dev/null
  echo "✅ Feature branch created with 1 commit"

  # Go back to main for merge
  echo "🔄 Switching back to main..."
  git checkout main >/dev/null
  
  # Debug: Show branch status
  echo "🔍 Debug - Current branches:"
  git branch -a
  echo "🔍 Debug - Current branch: $(git branch --show-current)"

  # Load smartmerge function
  echo "⚡ Loading smartmerge function..."
  source ../smartmerge.sh

  # Perform merge
  echo "🔀 Performing fast-forward merge..."
  smartmerge feature main

  # Verify
  local commit_count=$(git rev-list --count main)
  echo "📊 Final commit count: $commit_count"
  
  if [ "$commit_count" -eq 2 ]; then
    echo "✅ PASSED: Fast-forward merge successful!"
  else
    echo "❌ FAILED: Expected 2 commits, got $commit_count"
    echo "🔍 Debug - Commit log:"
    git log --oneline
  fi

  cd - >/dev/null && rm -rf "$test_dir"
  echo "🧹 Cleaned up test directory"
  echo
}