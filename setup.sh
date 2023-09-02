#!/bin/sh
export D=/home/jails
echo "$D" > vars.txt
mkdir -p $D

mkdir -p $D/dev/
mknod -m 666 $D/dev/null c 1 3
mknod -m 666 $D/dev/tty c 5 0
mknod -m 666 $D/dev/zero c 1 5
mknod -m 666 $D/dev/random c 1 8

chown root:root $D
chmod 0755 $D

#verify:
#ls -ld $D
echo "Install bash shell in $D"
mkdir -p $D/bin

cp -v /bin/bash $D/bin
mkdir -p $D/lib/
mkdir -p $D/lib64/
mkdir -p $D/lib/x86_64-linux-gnu/

ldd /bin/bash | awk '/=>/ {print $1}' | xargs -I '{}' cp '/lib/x86_64-linux-gnu/{}' $D/lib/
cp /lib64/ld-linux-x86-64.so.2 $D/lib64/
cp -a /lib/x86_64-linux-gnu/libnss_files* $D/lib/x86_64-linux-gnu/

cp -r /lib/terminfo $D/lib/terminfo
