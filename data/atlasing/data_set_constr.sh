#!/bin/bash

# If the file was already there delete it
file="data_set.xml"

if [ -f $file ] ; then
    rm $file
fi

# Input variable
model=$1

# Set up the string variables that will go on each line
heading1='<?xml version="1.0"?>'
heading2='<data_set>'
heading3='<subject id="'
heading4='">'
heading5='<visit id="experiment">'
heading6a='<filename object_id="'
heading6b='">'
# heading6="${heading6a}${NAME}${heading6b}"
heading7='</filename>'
heading8='</visit>'
heading9='</subject>'
heading10='</data_set>'

# VTK meshes that will be included in the pipeline
meshes=$(ls *.vtk)


# create a data_set.xml file and fill it up with the meshes information
echo ${heading1} >> data_set.xml
echo ${heading2} >> data_set.xml
for i in $meshes
 do
 if [ "$i" != "initial_template.vtk" ]
    then
     echo "        ${heading3}${i}${heading4}" >> data_set.xml
     echo "                ${heading5}" >> data_set.xml
     echo "                        ${heading6a}${model}${heading6b}${i}${heading7}" >> data_set.xml
     echo "                ${heading8}" >> data_set.xml
     echo "        ${heading9}" >> data_set.xml
 fi
done
echo ${heading10} >> data_set.xml

# Data has been saved
# echo "Specimens' information has been saved to data_set.xml"

### end of script ###

# If you have any questions or suggestions you can contact Marta Vidal-Garcia (marta.vidalga@gmail.com)

