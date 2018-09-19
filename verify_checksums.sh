#!/bin/bash
zipapp=xz
if command -v pixz > /dev/null 2>&1 ; then zipapp=pixz; fi

function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  [[ $D > 0 ]] && printf '%d days ' $D
  [[ $H > 0 ]] && printf '%d hours ' $H
  [[ $M > 0 ]] && printf '%d minutes ' $M
  [[ $D > 0 || $H > 0 || $M > 0 ]] && printf 'and '
  printf '%d seconds\n' $S
}

for image in $(cat images_list.txt);
do
    echo Checking ${image}...
    filename=${image//\//_}
    filename=${filename//\:/-}
    SECONDS=0
    docker save ${image} | tar xO | md5sum
    tar --use-compress-prog=${zipapp} -O -xf ${filename}.tar.xz | md5sum
    echo Elapsed time $(displaytime $SECONDS)
done

