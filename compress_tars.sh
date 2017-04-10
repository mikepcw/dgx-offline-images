#!/bin/bash
bz2app=bzip2
if command -v lbzip2 > /dev/null 2>&1 ; then bz2app=lbzip2; fi
if command -v pbzip2 > /dev/null 2>&1 ; then bz2app=pbzip2; fi

version=17.03
for image in *.tar;
do
    $bz2app -vk $image
done
