#!/bin/bash
# Remap AltGr+ø/æ to ö/ä (MD600 keyboard legends)
tmpfile=$(mktemp)
xkbcomp "$DISPLAY" "$tmpfile" 2>/dev/null
sed -i 's/dead_acute, dead_doubleacute/odiaeresis,      Odiaeresis/' "$tmpfile"
sed -i 's/dead_circumflex,      dead_caron/adiaeresis,      Adiaeresis/' "$tmpfile"
xkbcomp "$tmpfile" "$DISPLAY" 2>/dev/null
rm -f "$tmpfile"
