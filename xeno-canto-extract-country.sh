#!/bin/bash

# Tiny script to extract all bird calls from xeno-canto
# for a specific country.
# Save this script to a file    
# make it executable, at the shell prompt do
# $ chmod +x xeno-canto-extract-country.sh
    
# Invoke as e.g
# $ ./xeno-canto-extract-country.sh Sweden
# or
# $ ./xeno-canto-extract-country.sh Ethiopia
# It will store all mp3 files in the current directory    
# Author: klacke@hyber.org  (Claes Wikstrom)
    

country=$1
if [ -z "$country" ]; then
    echo "usage: $0 country"
    exit 1
fi

page=1
tmp=/tmp/xeno-canto.$$

while true; do
    curl -s "http://www.xeno-canto.org/browse.php?query=+cnt%3A%22${country}%22&pg=${page}" > ${tmp}

    count=`cat ${tmp} | grep http |grep mp3 | wc -l`
    echo "Page $page with $count mp3 files"
    page=`expr $page + 1`
    if [ $count = 0 ]; then
        rm ${tmp} 2> /dev/null
	exit 0
    fi
    for line in `cat ${tmp} | grep http|grep mp3 | \
	sed 's/.*http://' | sed 's/.mp3.*//' `; do
        url=http:${line}.mp3
	echo ${url}
	curl -O ${url}
    done
done
