# dgx-offline-images
Convenience scripts originally created to aid in the saving and loading of compressed docker images for DGX systems. Useful for archiving images from an internet-connected machine and loading them into an airgapped system. The `dgx` in the name and examples are for historical reasons. These scripts can be trivially modified to work with any system and docker repository.

In order to `docker pull` from the `nvcr.io/nvidia` repository, you need to be authenticated using your API key which can be generated from https://ngc.nvidia.com (on the machine connected to the internet).

Utilises a multithreaded implementation `xz` (`pixz`) where available for archive compression and decompression. The `.tar.xz` archives created by `pixz` are compatible with the standard (single threaded) system `xz` tool.

Most scripts will print out timing information. See note below about performance.

Examples of console output from successful save, load and verify runs are included.

## Naming convention
The generated archives automatically inherit the full docker repository name and tag info. The forward slashes are replaced with underscores, while the colons are replaced with dashes, to ensure portability across filesystems. e.g.:

The image `nvcr.io/nvidia/caffe-18.08-py2` is saved as `nvcr.io_nvidia_caffe-18.08-py2.tar.xz`.

# Usage
Edit `images_list.txt` to include only the docker images you wish to archive (see below).
Run the following on an internet-connected system that is already authenticated with your `nvcr.io` API key:
```
git clone https://github.com/mikepcw/dgx-offline-images
cd dgx-offline-images
./save_compressed_tars.sh
```
Then verify the checksums of the archived images:
```
./verify_checksums.sh
```
Finally, copy the created archives to the offline machine with docker already installed and load them using:
```
./load_compressed_tars.sh
```

If you already have uncompressed tars produced from a `docker save` operation, you can perform only the compression step using `compress_tars.sh`. See note below about when comparing checksums of the archives themselves between runs.

## Improving performance using pixz
It's a good idea to install `pixz` on both the internet-connected machine and the DGX system for *much* faster archive compression and decompression:
```
sudo apt update
sudo apt install pixz
```
The speed-up with `pixz` over the standard system `xz` tools cales roughly with number of CPU cores. i.e. a 10-core machine will be 10x faster to compress and decompress images.

Timing information is printed out from each compression/decompression operation for your convenience.

## images\_list.txt
Each line contains the full image name, including repository path and tag. This is the same format that is consumed by the `docker pull` command. 
One line per image you want to process. Remove what you don't want to archive.

The example `image_list.txt` includes only Python 3 versions of frameworks where Python 2 and 3 versions exist, and Python 2 otherwise.

# Compression and decompression
`pixz` -> `xz` (most -> least preferred)

## A note about checksums
The `docker save` command does not currently produce bit-reproducible `tar` files (due to differing date modified fields), so each time `docker save` is invoked, the resulting tar has a different checksum. Hence, the compressed result also has a different checksum, and the final archive cannot be compared by their checksums directly.

Also, `xz` and `pixz` by definition do not produce bit-reproducible (albeit compatible) archives. So comparing the archive file is meaningless. It's much better to verify the contents of the uncompressed (exploded) tarball inside.

To get consistent checksums, you need to check the exploded tarball with `tar xO` (uppercase 'O').
The `verify_checksums.sh` script demonstrates how to do this, and should be run immediately after creating compressed `.tar.xz` archives and before distribution.

### Validity of the archives after copying to airgapped machine
Note the `verify_checksums.sh` can only guarantee that the images inside `.tar.xz` were validly created *on the internet-connected machine*. The same check cannot be performed on the airgapped machine if it has no access to the remote repository. Therefore, it woudld be a good idea to verify the checksum of the archives themselves after transfer, and before loading the archives, on the airgapped machine. 

Example checksum verification output for 18.08 images:
```
test@dgx-1:~/docker$ ./verify_checksums.sh
Checking nvcr.io/nvidia/caffe:18.08-py2...
5099685a5cf859b7e108165079211ce4  -
5099685a5cf859b7e108165079211ce4  -
Elapsed time 1 minutes and 9 seconds
Checking nvcr.io/nvidia/caffe2:18.08-py3...
5df3d1a678d751d7a3ba5246e7dbad02  -
5df3d1a678d751d7a3ba5246e7dbad02  -
Elapsed time 37 seconds
Checking nvcr.io/nvidia/cntk:18.08-py3...
29fa28ff40faaf4423f48829ac44a241  -
29fa28ff40faaf4423f48829ac44a241  -
Elapsed time 1 minutes and 50 seconds
Checking nvcr.io/nvidia/cuda:9.0-cudnn7.2-devel-ubuntu16.04...
4c5f4f045698babec3a64edb1f58d900  -
4c5f4f045698babec3a64edb1f58d900  -
Elapsed time 19 seconds
Checking nvcr.io/nvidia/digits:18.08...
...
```
