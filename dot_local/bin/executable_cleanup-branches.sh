#!/bin/bash

# Fetch all branches and prune remote-tracking branches that no longer exist
git fetch --all --prune

# Store the current branch
original_branch=$(git branch --show-current)

# Get a list of all local branches, excluding 'main' and branches that start with '_'
branches=$(git branch --format="%(refname:short)" | grep -v '^main$' | grep -v '^_')

if [ -z "$branches" ]; then
  echo "No branches found for cleanup."
  exit 0
fi

# Iterate over each branch and check if it contains any commits not in 'main'
for branch in $branches; do
  # Check if branch has any unique commits compared to 'main'
  unique_commits=$(git rev-list --count $branch ^main)

  if [ "$unique_commits" -eq 0 ]; then
    # No unique commits, offer to delete
    echo "Branch '$branch' is fully included in 'main' and can be deleted."
    read -p "Do you want to delete branch '$branch'? (y/n): " choice
    if [ "$choice" = "y" ]; then
      git branch -d "$branch"
      echo "Deleted branch '$branch'."
    else
      echo "Skipped branch '$branch'."
    fi
  else
    # Unique commits exist, show the diff as if 'main' was merged into the branch
    echo "Branch '$branch' has $unique_commits unique commit(s) not in 'main'."
    echo "Showing the diff between 'main' and '$branch' as if 'main' was merged into '$branch':"

    # Switch to the branch
    git checkout "$branch" > /dev/null 2>&1

    # Perform a merge without committing, to simulate the merge
    git merge --no-commit --no-ff main

    # Show the colored diff for the merge result
    git diff main --color

    # Abort the merge to return to the original branch state
    git merge --abort

    # Switch back to the original branch
    git checkout "$original_branch" > /dev/null 2>&1

    # Offer to delete the branch after showing the diff
    read -p "Do you want to delete branch '$branch' despite unique commits? (y/n): " choice

    if [ "$choice" = "y" ]; then
      git branch -D "$branch"
      echo "Deleted branch '$branch'."
    else
      echo "Skipped branch '$branch'."
    fi
  fi
done

echo "Finished processing branches."
