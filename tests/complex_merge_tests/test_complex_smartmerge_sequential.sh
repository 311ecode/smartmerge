#!/bin/bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.
test_complex_smartmerge_sequential() {
  echo "=== TEST 1: SEQUENTIAL MERGE (EXPECT 4 COMMITS) ==="
  local test_dir=$(mktemp -d)
  cd "$test_dir" || return 1

  # Setup repo with 3 initial commits
  git init >/dev/null
  git config --local user.name "Test"
  git config --local user.email "test@example.com"
  for i in {1..3}; do
    echo "main-$i" >file$i
    git add file$i
    git commit -m "Main commit $i" >/dev/null
  done

  # Create feature branch with 5 commits
  git checkout -b feature >/dev/null
  for i in {1..5}; do
    echo "feature-$i" >feature$i
    git add feature$i
    git commit -m "Feature commit $i" >/dev/null
  done

  # Merge back to main
  git checkout main >/dev/null
  smartmerge feature main

  # Verify commit count
  local commit_count=$(git rev-list --count main)
  if [ "$commit_count" -eq 4 ]; then
    echo "✅ Passed: Found $commit_count commits (main commits + 1 squash)"
  else
    echo "❌ Failed: Expected 4 commits, got $commit_count"
    git log --oneline
  fi

  cd - >/dev/null && rm -rf "$test_dir"
  echo
}
