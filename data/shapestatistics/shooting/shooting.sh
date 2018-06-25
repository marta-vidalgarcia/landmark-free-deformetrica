#!/bin/bash

#Moving to the local directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $dir

deformetrica shooting 3D model_forward.xml data_set.xml optimization_parameters.xml --output-dir=forward
deformetrica shooting 3D model_backward.xml data_set.xml optimization_parameters.xml --output-dir=backward


mkdir -p combined
cd backward
for f in `ls *.vtk`;
do
  nf=${f%\.vtk};
  n=`echo $nf | rev | awk -F"_" '{print $1}' | rev`;
  nn=`expr 19 - $n`;
  outn=$(printf "%02d" $nn);
  echo $n $outn;
  cp $f ../combined/separation_$outn.vtk;
done

cd ../forward
for f in `ls *.vtk`;
do
  nf=${f%\.vtk};
  n=`echo $nf | rev | awk -F"_" '{print $1}' | rev`;
  nn=`expr $n + 20`;
  outn=$(printf "%02d" $nn);
  echo $n $outn;
  cp $f ../combined/separation_$outn.vtk;
done

cd ../combined

for f in `ls *.vtk`;
do
  nf=${f%\.vtk};
  n=`echo $nf | rev | awk -F"_" '{print $1}' | rev`;
  nn=`expr 39 - $n + 40`;
  outn=$(printf "%02d" $nn);
  echo $n $outn;
cp $f separation_$outn.vtk; done

cd ../
