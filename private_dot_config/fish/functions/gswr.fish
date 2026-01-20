function gswr --description "Git switch branch and reset to origin/main"
  command git -c core.hooksPath=/dev/null switch $argv[1] && git reset --hard origin/main
end
