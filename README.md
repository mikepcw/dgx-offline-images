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
