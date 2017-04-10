# dgx1-offline-images
Convenience scripts to save and load compressed docker images for DGX-1

Utilises multithreaded implementations of bzip2 (lbzip2 or pbzip2) where available. The .bz2 archives created by all three tools are compatible with the standard (single threaded) system bzip tool.

## Decompression
lbzip2 -> pbzip2 -> bzip2 (most -> least preferred)

Since lbzip2 can efficiently decompress archives created by all other tools.

## Compression
pbzip2 -> lbzip2 -> bzip2 (most -> least preferred)

Since pbzip2 can only decompress archives created by itself efficiently.

## A note about checksums
The `docker save` command does not currently produce bit-reproducible tar files (due to differing date modified fields), so each time `docker save` is invoked, the resulting tar has a different checksum.

To get consistent checksums, you need to check the exploded tarball with `tar xO` (uppercase 'o').
The `verify_checksums.sh` script demonstrates how to do this, and should be run on the created .tar.bz2 archives before distribution.

Example checksum verification for 17.03 images:
```
test@dgx-1:~/docker$ ./verify_checksums.sh
caffe:17.03
fc44693a168298a07ab2d8aba8683748  -
fc44693a168298a07ab2d8aba8683748  -
cntk:17.03
598c443fca6ba9eaee178449f13b217c  -
598c443fca6ba9eaee178449f13b217c  -
digits:17.03
eefd44bf83a1c176ceafe387b2cf29de  -
eefd44bf83a1c176ceafe387b2cf29de  -
mxnet:17.03
5c94873bd10805f558f9c8df0a9d71bb  -
5c94873bd10805f558f9c8df0a9d71bb  -
tensorflow:17.03
071b95b31d24acd10d6e75fae461e5e4  -
071b95b31d24acd10d6e75fae461e5e4  -
theano:17.03
fe5e5c63cd115a431ba0daeac6e3cd0c  -
fe5e5c63cd115a431ba0daeac6e3cd0c  -
torch:17.03
1cd562e5a8657339e998ace9ccb30a08  -
1cd562e5a8657339e998ace9ccb30a08  -
cuda:8.0-cudnn6-devel-ubuntu16.04
acb27eeffe7fda97a2ec7be4879e331d  -
acb27eeffe7fda97a2ec7be4879e331d  -
```
