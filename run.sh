#!/bin/bash
# Script to run Simulation
#
# Written by Bryan Laygond
#

# Run compiled code
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd  $DIR
cd ros
roslaunch launch/styx.launch