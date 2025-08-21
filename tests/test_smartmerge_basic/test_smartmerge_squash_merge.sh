#!/usr/bin/env bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.
test_smartmerge_squash_merge() {
  echo "📦 === TEST: SQUASH MERGE ==="
  local test_dir=$(mktemp -d)
  echo "📁 Created test directory: $test_dir"
  cd "$test_dir" || return 1

  # Setup repo
  echo "🔧 Setting up Git repository..."
  git init >/dev/null
  git config --local user.name "Test"
  git config --local user.email "test@example.com"

  # Create main branch with initial commits
  echo "🌟 Creating main branch with initial commits..."
  for i in {1..2}; do
    echo "main-$i" > "main$i.txt"
    git add "main$i.txt"
    git commit -m "Main commit $i" >/dev/null
    echo "✅ Created main commit $i"
  done
  git branch -M main

  # Create feature branch with multiple commits
  echo "🌿 Creating feature branch with multiple commits..."
  git checkout -b feature >/dev/null
  for i in {1..3}; do
    echo "feature-$i" > "feature$i.txt"
    git add "feature$i.txt"
    git commit -m "Feature commit $i" >/dev/null
    echo "✅ Created feature commit $i"
  done

  # Add one more commit to main to force divergence
  echo "🔄 Adding divergent commit to main..."
  git checkout main >/dev/null
  echo "main-3" > "main3.txt"
  git add "main3.txt"
  git commit -m "Main commit 3" >/dev/null
  echo "✅ Created divergent main commit"

  # Debug: Show branch status
  echo "🔍 Debug - Current branches:"
  git branch -a
  echo "🔍 Debug - Main commits:"
  git log main --oneline
  echo "🔍 Debug - Feature commits:"
  git log feature --oneline

  # Load smartmerge function
  echo "⚡ Loading smartmerge function..."
  source ../smartmerge.sh

  # Perform squash merge
  echo "🔀 Performing squash merge..."
  smartmerge --debug feature main

  # Verify
  local commit_count=$(git rev-list --count main)
  echo "📊 Final commit count: $commit_count"

  if [ "$commit_count" -eq 4 ]; then
    echo "✅ PASSED: Squash merge successful!"
    echo "🔍 Final commit log:"
    git log main --oneline
  else
    echo "❌ FAILED: Expected 4 commits, got $commit_count"
    echo "🔍 Debug - Final commit log:"
    git log main --oneline
  fi

  cd - >/dev/null && rm -rf "$test_dir"
  echo "🧹 Cleaned up test directory"
  echo
}
