#!/bin/bash
zipapp=xz
if command -v pixz > /dev/null 2>&1 ; then zipapp=pixz; fi

for tarball in *.tar;
do
    echo Compressing ${tarball}...
    ${zipapp} -k ${tarball} ${tarball}.xz
    echo Done!
done
