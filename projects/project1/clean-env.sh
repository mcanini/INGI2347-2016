#!/bin/bash
F="$1"
shift

ulimit -s unlimited

DIR=$(cd -P -- "$(dirname -- "$F")" && pwd -P)
FILE=$(basename -- "$F")
if [ "$DIR" != /project1 ]; then
    echo "========================================================"
    echo "WARNING: Lab directory is $DIR"
    echo "Make sure your lab is checked out at /project1 or"
    echo "your solutions may not work when grading."
    echo "========================================================"
fi
exec env - PWD="$DIR" SHLVL=0 "$DIR/$FILE" "$@"
