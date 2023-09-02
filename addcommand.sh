#!/bin/sh
#add command to jail
D=$(cat vars.txt)

if [ $# -ne 1 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

COMMAND=$1

cp -v /bin/$COMMAND $D/bin
ldd /bin/$COMMAND | awk '/=>/ {print $1}' | xargs -I '{}' cp '/lib/x86_64-linux-gnu/{}' $D/lib/
