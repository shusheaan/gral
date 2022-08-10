#!/usr/bin/zsh

# install .deb packages
PACKAGES=($(ls -a | grep .deb))
for PACKAGE in $PACKAGES; do 
    sudo apt install "./$PACKAGE" 
done

