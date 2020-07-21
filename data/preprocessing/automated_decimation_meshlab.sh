#!/bin/bash
# Usage: Automate decimation in meshlab
# ./automated_decimation_meshlab.sh input_pattern output_pattern (e.g. ./automated decimation_meshlab.sh ply _decimated.ply

in_pattern=$1
out_pattern=$2

if ! command -v meshlabserver &> /dev/null
then
    echo "Meshlab could not be found. Please install meshlab and then run this again"
    exit
fi

for file in *${in_pattern}; do
echo "Decimating ${file}"
    meshlabserver -i "$file" -o "${file%.*}${out_pattern}" -s "auto_meshlab_decimation.mlx" -om vc
done
echo "All meshes have been processed"

# If you have any questions or suggestions you can contact Marta Vidal-Garcia (marta.vidalga@gmail.com)
