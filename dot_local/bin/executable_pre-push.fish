#!/usr/bin/env fish

#
# pre-push hook in Fish shell
# Blocks pushing branches that start with an underscore ("_")
#

while read local_ref local_sha remote_ref remote_sha
    # local_ref looks like "refs/heads/my_branch"
    # let's extract the branch name by splitting on "/"
    set branch_name (string split "/" $local_ref)[3]

    if test (string sub -l 1 $branch_name) = "_"
        echo "ERROR: Pushing a branch starting with '_' is disallowed: $branch_name"
        exit 1
    end
end

# If we get here, no invalid branches were found
exit 0
