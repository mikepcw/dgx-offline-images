#!/bin/bash

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
    echo Pulling ${image}...
    filename=${image//\//_}
    filename=${filename//\:/-}
    docker pull ${image}
    echo Saving ${filename}.tar.xz...
    SECONDS=0
    docker save ${image} -o ${filename}.tar
    echo Elapsed time $(displaytime $SECONDS)
    echo Done!
done

