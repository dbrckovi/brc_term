#!/bin/bash -eu

OUT_DIR="out"
./build.sh

if [[ $TERM == "xterm-kitty" ]]
then
  kitty @ launch --type=tab --cwd current ./out/tester.bin > /dev/null
  sleep 0.1
else
  ./out/tester.bin
fi