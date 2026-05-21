# Hook __fnm_autoswitch into every directory change and at shell start.
# This replaces fnm's built-in --use-on-cd, which only inspects the current
# directory; ours walks upward so a single .nvmrc at a repo root applies to all
# subfolders unless a closer version file overrides it.

if status --is-interactive
    function __fnm_autoswitch_on_pwd --on-variable PWD --description "Re-run fnm autoswitch when PWD changes"
        __fnm_autoswitch
    end

    # Run once at shell startup so we land on the right version even without a cd.
    __fnm_autoswitch
end
