#!/bin/bash
VAR=$($DR_ENGINE $DR_HOME/dist/directory-repository.py --go $1);
echo "Changing working directory: $VAR";
cd $VAR;
