#!/bin/bash

systems=(
    bionic
    trusty
)

for system in "${systems[@]}"
do
    echo "************************* Cleanup $system ********************************"
    cd $system
    vagrant halt
    vagrant destroy -f
    rm -rf build/
    rm -rf build_debs/
    rm *.log
    rm -rf .vagrant
    cd ..
done
