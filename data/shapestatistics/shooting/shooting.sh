#!/bin/bash

#Moving to the local directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $dir

deformetrica shooting 3D model_forward.xml data_set.xml optimization_parameters.xml --output-dir=forward
deformetrica shooting 3D model_backward.xml data_set.xml optimization_parameters.xml --output-dir=backward
