#!/bin/bash

# convert BAM to SAM

if [[ $1 == "--help" ]]
then
   echo "Converts all *.bam files in the folder in SAM.
   The program places the output SAM files in a new directory named BAM
   
   Usage bam_to_sam.sh <number of cores>" 

   # TODO write the command executed from the script

else


    mkdir SAM


    for file in ./*.bam
    do
        echo "converting $file to SAM"
        samtools view -@ $1 -h -o SAM/${file%.bam}.sam $file
    done
fi

