#!/bin/bash
cd "$(dirname $0)"
find . -name \*.dot | while read input
do outfile=$(basename $input)
   output="./static/dot/${outfile%%.dot}.png"
   dot -Tpng $input -o$output
done 
