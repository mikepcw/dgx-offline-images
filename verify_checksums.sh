#!/bin/bash
bz2app=bzip2
if command -v pbzip2 > /dev/null 2>&1 ; then bz2app=pbzip2; fi
if command -v lbzip2 > /dev/null 2>&1 ; then bz2app=lbzip2; fi

version=17.05
for image in caffe caffe2 cntk digits mxnet pytorch tensorflow theano torch;
do
    echo $image:$version
    docker save nvcr.io/nvidia/$image:$version | tar xO | md5sum
    tar --use-compress-prog=$bz2app -O -xf $image-$version.tar.bz2 | md5sum
done

cudatag=8.0-cudnn6-devel-ubuntu16.04
echo cuda:$cudatag
docker save nvcr.io/nvidia/cuda:$cudatag | tar xO | md5sum
tar --use-compress-prog=$bz2app -O -xf cuda-$cudatag.tar.bz2 | md5sum

