#!/bin/bash
bz2app=bzip2
if command -v lbzip2 > /dev/null 2>&1 ; then bz2app=lbzip2; fi
if command -v pbzip2 > /dev/null 2>&1 ; then bz2app=pbzip2; fi

version=17.04
for image in caffe caffe2 cntk digits mxnet tensorflow theano torch;
do
    docker pull nvcr.io/nvidia/$image:$version
    docker save nvcr.io/nvidia/$image:$version | ${bz2app} -v > $image-$version.tar.bz2
done

cudatag=8.0-cudnn6-devel-ubuntu16.04
docker pull nvcr.io/nvidia/cuda:$cudatag
docker save nvcr.io/nvidia/cuda:$cudatag | ${bz2app} -v > cuda-$cudatag.tar.bz2
