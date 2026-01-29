#!/bin/sh
while read f; do
    echo $f
    cat "$f".part* > "$f"
done <vsix.lst
