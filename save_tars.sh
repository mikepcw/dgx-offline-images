#!/bin/bash

for image in $(cat images_list.txt);
do
    echo Pulling ${image}...
    filename=${image//\//_}
    filename=${filename//\:/-}
    docker pull ${image}
    echo Saving ${filename}.tar.xz...
    docker save ${image} -o ${filename}.tar
    echo Done!
done

