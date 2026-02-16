#!/bin/bash -eu

OUT_DIR="out"
mkdir -p $OUT_DIR
odin build tester -out:$OUT_DIR/tester.bin -debug

