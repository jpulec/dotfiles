#!/usr/bin/env bash

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository."
  exit 1
fi

base_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')"
if [[ -z "$base_branch" ]]; then
  if git show-ref --verify --quiet refs/heads/main; then
    base_branch="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    base_branch="master"
  else
    echo "Could not determine default base branch (origin/HEAD, main, or master)."
    exit 1
  fi
fi

current_branch="$(git branch --show-current)"

echo "Using base branch: $base_branch"
git fetch --all --prune

branches="$({
  git branch --format='%(refname:short)' \
    | grep -v "^${base_branch}$" \
    | grep -v '^_' \
    | grep -v "^${current_branch}$"
} || true)"

if [[ -z "$branches" ]]; then
  echo "No local branches found for cleanup."
  exit 0
fi

for branch in $branches; do
  unique_commits="$(git rev-list --count "$branch" "^${base_branch}")"

  if [[ "$unique_commits" -eq 0 ]]; then
    echo "Branch '$branch' is fully included in '$base_branch' and can be deleted."
    read -r -p "Delete branch '$branch'? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
      git branch --delete "$branch"
      echo "Deleted branch '$branch'."
    else
      echo "Skipped branch '$branch'."
    fi
  else
    echo "Branch '$branch' has $unique_commits unique commit(s) not in '$base_branch'."
    echo "Showing diff for '${base_branch}...${branch}':"
    git --no-pager diff --color=always "${base_branch}...${branch}" || true

    read -r -p "Delete branch '$branch' despite unique commits? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
      git branch --delete --force "$branch"
      echo "Deleted branch '$branch'."
    else
      echo "Skipped branch '$branch'."
    fi
  fi
done

echo "Finished processing branches."
