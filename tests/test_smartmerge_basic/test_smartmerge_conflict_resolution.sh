#!/usr/bin/env bash
test_smartmerge_conflict_resolution() {
  echo "⚔️ === TEST: CONFLICT RESOLUTION ==="
  local test_dir=$(mktemp -d)
  echo "📁 Created test directory: $test_dir"
  cd "$test_dir" || return 1

  # Setup repo
  echo "🔧 Setting up Git repository..."
  git init >/dev/null
  git config --local user.name "Test"
  git config --local user.email "test@example.com"
  
  # Create main branch
  echo "🌟 Creating main branch..."
  echo "original content" > conflict.txt
  git add conflict.txt
  git commit -m "Initial commit" >/dev/null
  git branch -M main
  echo "✅ Main branch created"

  # Create feature branch with conflicting change
  echo "🌿 Creating feature branch with conflict..."
  git checkout -b feature >/dev/null
  echo "feature content" > conflict.txt
  git add conflict.txt
  git commit -m "Feature change" >/dev/null

  # Add conflicting change to main
  echo "🔄 Adding conflicting change to main..."
  git checkout main >/dev/null
  echo "main content" > conflict.txt
  git add conflict.txt
  git commit -m "Main change" >/dev/null

  # Debug: Show branch status
  echo "🔍 Debug - Current branches:"
  git branch -a
  echo "🔍 Debug - File contents in main:"
  cat conflict.txt

  # Load smartmerge function
  echo "⚡ Loading smartmerge function..."
  source ../smartmerge.sh

  # Attempt merge (should handle conflict)
  echo "🔀 Attempting merge with conflict..."
  if smartmerge feature main; then
    echo "❌ UNEXPECTED: Merge should have failed due to conflict"
  else
    echo "✅ EXPECTED: Merge failed as expected due to conflict"
  fi

  cd - >/dev/null && rm -rf "$test_dir"
  echo "🧹 Cleaned up test directory"
  echo
}