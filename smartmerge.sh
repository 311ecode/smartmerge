#!/bin/bash
# Copyright © 2025 Imre Toth <tothimre@gmail.com> - Proprietary Software. See LICENSE file for terms.

smartmerge() {
  eval "$(markdown-show-help-registration --minimum-parameters 1)"
  # Debug mode
  local debug=false
  [[ $1 == "--debug" ]] && {
    debug=true
    shift
  }

  # Validate parameters
  if [ $# -ne 2 ]; then
    echo "Usage: smartmerge [--debug] <source-branch> <target-branch>"
    return 1
  fi

  local source_branch="$1"
  local target_branch="$2"
  local current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)

  # Debug output
  $debug && {
    echo "=== PRE-MERGE STATE ==="
    echo "Source branch '$source_branch' commits:"
    git log "$source_branch" --oneline -n 3
    echo "Target branch '$target_branch' commits:"
    git log "$target_branch" --oneline -n 3
    echo "======================="
  }

  # Validate branches
  if ! git show-ref --verify --quiet "refs/heads/$source_branch"; then
    echo "Error: Source branch '$source_branch' does not exist."
    return 1
  fi
  if ! git show-ref --verify --quiet "refs/heads/$target_branch"; then
    echo "Error: Target branch '$target_branch' does not exist."
    return 1
  fi

  # Stash changes
  $debug && echo "Stashing current changes..."
  git stash push -m "smartmerge temporary stash" >/dev/null 2>&1
  local had_stash=$?

  # Perform merge
  git checkout "$target_branch" || return 1

  if git merge-base --is-ancestor "$target_branch" "$source_branch"; then
    $debug && echo "Performing fast-forward merge"
    git merge --ff-only "$source_branch" || return 1
  else
    $debug && {
      echo "Performing squash merge (will combine these commits):"
      git log --no-merges "$(git merge-base "$target_branch" "$source_branch")..$source_branch" --oneline
    }

    # Create squash commit with reference to original commits
    local commit_list=$(git log --no-merges --format="%h %s" "$(git merge-base "$target_branch" "$source_branch")..$source_branch")
    git merge --squash "$source_branch" || {
      echo "❌ Merge failed. Resolve conflicts and:"
      echo "   git add . && git commit -m 'Your message'"
      return 1
    }
    git commit -m "Merged $source_branch (squashed)
    
Contains changes from:
$commit_list" || {
      echo "❌ Failed to create squash commit"
      return 1
    }
  fi

  # Restore working directory
  if [ $had_stash -eq 0 ]; then
    $debug && echo "Restoring stashed changes..."
    git stash pop >/dev/null 2>&1
  fi

  # Return to original branch
  git checkout "$current_branch" >/dev/null 2>&1

  $debug && {
    echo "=== POST-MERGE STATE ==="
    echo "Target branch '$target_branch' commits:"
    git log "$target_branch" --oneline -n 3
    echo "Source branch '$source_branch' commits:"
    git log "$source_branch" --oneline -n 3
    echo "========================"
  }

  echo "✅ Successfully merged $source_branch into $target_branch"
  echo "Note: Original commits remain available in $source_branch branch"
}

registerToFunctionsDB
