#!/bin/bash
zipapp=xz
if command -v pixz > /dev/null 2>&1 ; then zipapp=pixz; fi

for archive in *.tar.xz;
do
    echo Loading ${archive}...
    ${zipapp} -dk < ${archive} | docker load
    echo Done!
done

