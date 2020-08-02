#!/bin/bash
# Script to delete old build and build it from scratch
#
# Written by Bryan Laygond

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd  $DIR
cd ros

if [ -d "build" ]; then
  rm -rf build
  echo [INFO] Got rid of old build!
fi
if [ -d "devel" ]; then
  rm -rf devel
  echo [INFO] Got rid of old devel!
fi

echo [INFO] Compiling new code
catkin_make
source devel/setup.bash

cd $DIR
