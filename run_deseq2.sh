#!/bin/bash

# Remove lines starting with ">" from configuration file

awk '!/^>/' $1 > config.tmp

# Assign lines of config.tmp as variables

declare -a array
while read -r
do 
    array+=( "$REPLY" )
done < config.tmp

# Call R script with and assign variables

echo deseq2.r ${array[1]} ${array[2]} ${array[3]} ${array[4]}
