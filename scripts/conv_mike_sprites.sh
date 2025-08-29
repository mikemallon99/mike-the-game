#!/bin/bash

in="/home/mike/toontown/me_sprites_unprocessed"
out="/home/mike/toontown/me_sprites_processed"

# These 2 must multiply back to 100%
small_w_p=15
large_w_p=666.67

posterize_levels=8  # set to 0 to skip posterize

echo ${out}
mkdir -p "$out"

for f in "$in"/*.{png,jpg,jpeg,JPG,JPEG,PNG}; do
  [ -e "$f" ] || continue
  bn=$(basename "$f")
  echo $f
  echo "$out/$bn"
  convert \
    "$f" \
    -scale ${small_w_p}% \
    -posterize ${posterize_levels} \
    -scale ${large_w_p}% \
    "$out/$bn"
done

