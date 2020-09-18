#!/bin/bash

for FILENAME in $(ls pcap-eth0*)
  do 
    FILEDATE=$(date +%Y%m%d%H%M%s --date="$(stat -c %y $FILENAME)")
    mv --no-clobber $FILENAME ${PWD##*/}-$FILEDATE.pcap
done