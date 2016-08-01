#! /usr/bin/env bash
script="$1"
shift

sh ./_scripts/$script $@

exit 0