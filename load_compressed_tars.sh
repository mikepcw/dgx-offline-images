#!/bin/bash
bz2app=bzip2
if command -v pbzip2 > /dev/null 2>&1 ; then bz2app=pbzip2; fi
if command -v lbzip2 > /dev/null 2>&1 ; then bz2app=lbzip2; fi

for archive in *.tar.bz2;
do
    ${bz2app} -dvck $archive | docker load
done

