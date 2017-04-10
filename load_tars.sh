#!/bin/bash

for archive in *.tar;
do
    docker load -i $archive
done

