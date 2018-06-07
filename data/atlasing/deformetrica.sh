#!/bin/bash

#Moving to the local directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $dir

# Atlas construction :
deformetrica atlas 3D model.xml data_set.xml optimization_parameters.xml --output-dir=. > deformetrica.log

cat deformetrica.log | grep Log-like | awk -F" " '{print $3, $7, $11}' | tr -d ] > convergence.txt
