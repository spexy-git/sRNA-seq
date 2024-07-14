#!/bin/bash
# The script converts all the .sam file the folder where you run the script in bam files and place them in a new directory (created by the script) called BAM. Output file will have the same name but a different extension (.bam)
# Usage: from the folder with the sam file run sam_to_bam.sh <number of cores to use>

if [[ $1 == "--help" ]]
then
   echo "Converts all *.sam files in the folder in BAM.
   The program places the output BAM files in a new directory named BAM
   
   Usage sam_to_bam.sh <number of cores>" 
# TODO write the command executed from the script
else

mkdir BAM

for sam in $(ls *.sam); do samtools view -@ $1 -S -b $sam -o BAM/${sam%.sam}.bam | echo "converting $sam to BAM" ; done

#TODO fix this! ls* .sam
echo "BAM file created and placed in the following folder: BAM"
fi
