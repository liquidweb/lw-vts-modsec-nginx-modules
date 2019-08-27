#!/bin/bash

systems=(
    bionic
    trusty
)

for system in "${systems[@]}"
do
    echo "************************* Cleanup $system ********************************"
    cd $system
    rm -rf build/
    rm -rf build_debs/
    rm -rf .vagrant
    rm *.log
    vagrant halt
    vagrant -f destroy
    cd ..
done
