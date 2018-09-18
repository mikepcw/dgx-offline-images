#!/bin/bash

for archive in *.tar;
do
    echo Loading ${archive}.tar...
    docker load -i $archive
    echo Done!
done

