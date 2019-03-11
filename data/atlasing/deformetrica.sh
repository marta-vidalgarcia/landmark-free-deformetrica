#!/bin/bash

#Moving to the local directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $dir

# Atlas construction :
deformetrica estimate model.xml data_set.xml -p optimization_parameters.xml --output=. -v DEBUG 2>&1 | tee deformetrica.log

# Gather convergence information
cat deformetrica.log | grep Log-like | awk -F" " '{print $4, $8, $12}' | tr -d ] > convergence.txt

# Simplify naming:
mv `ls *EstimatedParameters__Momenta.txt` Atlas_Momentas.txt
mv `ls *EstimatedParameters__ControlPoints.txt` Atlas_ControlPoints.txt
mv `ls *_EstimatedParameters__Template_*.vtk` Atlas_initial_template.vtk

