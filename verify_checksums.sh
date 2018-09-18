#!/bin/bash
zipapp=xz
if command -v pixz > /dev/null 2>&1 ; then zipapp=pixz; fi

for image in $(cat images_list.txt);
do
    echo Checking ${image}...
    filename=${image//\//_}
    filename=${filename//\:/-}
    docker save ${image} | tar xO | md5sum
    tar --use-compress-prog=${zipapp} -O -xf ${filename}.tar.xz | md5sum
done

