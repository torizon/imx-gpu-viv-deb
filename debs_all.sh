#! /usr/bin/env bash

time for d in $(find -maxdepth 1 -type d); do cd $d && ../build_deb.sh && cd -; done
