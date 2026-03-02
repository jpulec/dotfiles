#!/usr/bin/env fish

set PROFILE "Profile 2"
set CHROME google-chrome-stable

# Window 1: Live lesson
$CHROME \
  --profile-directory="$PROFILE" \
  --new-window \
  "https://calendar.google.com"

sleep 0.3

# Window 2: Materials
$CHROME \
  --profile-directory="$PROFILE" \
  --new-window \
  "https://docs.google.com/document/d/1S5tTXWg2upQr67E10Py55Agamy_rADWoge8agPN3g7I" \
  "file:///home/james/Downloads/Portugue%CC%82s-para-principiantes-1538054164.pdf" \
  "https://translate.google.com"
