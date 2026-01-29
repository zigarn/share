#!/bin/sh
: > vsix.lst
for f in *.vsix; do
    echo $f | tee --append vsix.lst
    split --bytes=5M "$f" "$f.part"
done
