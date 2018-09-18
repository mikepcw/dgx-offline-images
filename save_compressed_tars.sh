#!/bin/bash
zipapp=xz
if command -v pixz > /dev/null 2>&1 ; then zipapp=pixz; fi

for image in $(cat images_list.txt);
do
    echo Pulling ${image}...
    filename=${image//\//_}
    filename=${filename//\:/-}
    docker pull ${image}
    echo Saving ${filename}.tar.xz...
    docker save ${image} | ${zipapp} > ${filename}.tar.xz
    echo Done!
done

