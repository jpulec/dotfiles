function uptop
  while true
    if test "$PWD" = "$HOME"
      break
    end
    if test -e ./.git
      break
    end
    cd ..
  end
end
