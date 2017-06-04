#!/bin/bash

version=17.05
for image in caffe caffe2 cntk digits mxnet pytorch tensorflow theano torch;
do
    docker pull nvcr.io/nvidia/$image:$version
    docker save nvcr.io/nvidia/$image:$version -o $image-$version.tar
done

cudatag=8.0-cudnn6-devel-ubuntu16.04
docker pull nvcr.io/nvidia/cuda:$cudatag
docker save nvcr.io/nvidia/cuda:$cudatag -o cuda-$cudatag.tar
