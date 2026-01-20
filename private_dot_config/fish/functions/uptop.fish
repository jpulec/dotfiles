function uptop --description "Navigate to git repository root"
  set --local toplevel (git rev-parse --show-toplevel 2>/dev/null)
  if test -n "$toplevel"
    cd "$toplevel"
  else
    echo "Not in a git repository" >&2
    return 1
  end
end
