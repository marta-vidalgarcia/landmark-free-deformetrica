#!/bin/bash

# If the file was already there delete it
file="model.xml"

if [ -f $file ] ; then
    rm $file
fi

# Input variable
model_type=$1
object_id=$2
object_type=$3
template=$4
kernel_type=$5
kernel_width=$6
timepoints=$7

# Set up the string variables that will go on each line
h1='<?xml version="1.0"?>'
h2='<model>'
h3a='<model-type>'
h3b='</model-type>'
h4='<dimension>3</dimension>'
h5='<template>'
h6a='<object id="'
h6b='">'
h7a='<deformable-object-type>'
h7b='</deformable-object-type>'
h8='<attachment-type>current</attachment-type>'
h9='<noise-std>1</noise-std>'
h10a='<kernel-type>'
h10b='</kernel-type>'
h11a='<kernel-width>'
h11b='</kernel-width>'
h12a='<filename>'
h12b='</filename>'
h13='</object>'
h14='</template>'
h15='<deformation-parameters>'
h16a='<kernel-width>'
h16b='</kernel-width>'
h17a='<kernel-type>'
h17b='</kernel-type>'
h18a='<number-of-timepoints>'
h18b='</number-of-timepoints>'
h19='</deformation-parameters>'
h20='</model>'

# Save to file
echo ${h1} >> model.xml
echo ${h2} >> model.xml
echo "    ${h3a}${model_type}${h3b}" >> model.xml
echo "    ${h4}" >> model.xml
echo "    ${h5}" >> model.xml
echo "        ${h6a}${object_id}${h6b}" >> model.xml
echo "            ${h7a}${object_type}${h7b}" >> model.xml
echo "            ${h8}" >> model.xml
echo "	    ${h9}" >> model.xml
echo "            ${h10a}${kernel_type}${h10b}" >> model.xml
echo "            ${h11a}${kernel_width}${h11b}" >> model.xml
echo "            ${h12a}${template}${h12b}" >> model.xml
echo "        ${h13}" >> model.xml
echo "    ${h14}" >> model.xml
echo "    ${h15}" >> model.xml
echo "	    ${h16a}${kernel_width}${h16b}" >> model.xml
echo "        ${h17a}${kernel_type}${h17b}" >> model.xml
echo "        ${h18a}${timepoints}${h18b}" >> model.xml
echo "    ${h19}" >> model.xml
echo ${h20} >> model.xml


### end of script ###

# If you have any questions or suggestions you can contact Marta Vidal-Garcia (marta.vidalga@gmail.com)
