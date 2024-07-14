#!/bin/bash
# info on samtools view used in this script http://www.htslib.org/doc/samtools-view.html
# Usage: region_from_bam.sh <region> <output format (sam or bam)> <number of processors>
# format for region: chromosome:1-240. Chromosome = the name of the regione in the genome you used for mapping. You can extrat it from the header of sam file or from the genome.

# Display help file with --help option

if [[ $1 == "--help" ]]
then
echo "Script to extract reads mapping only to a specific portion of the genome using samtools view. 
Usage: region_from_bam.sh <region> <output format (sam or bam)> <number of processors>"
# TODO write the command executed from the script
else

# Change ":" with "_" in file name
buz=$(echo $1 | sed 's/\:/_/')




# Creates bam or sam output depending on the input ($2) of the script
if [[ $2 == "sam" ]]

then

mkdir sam_from_region_$buz

for fiz in $(ls *.bam); do samtools view -@ $3 -h $fiz -o sam_from_region_$buz/${fiz%.bam}_${buz}.sam $1 | echo sam file from region $1 created with the following name ${fiz%.bam}_${buz}.sam; done

else

mkdir bam_from_region_$buz

for fiz in $(ls *.bam); do samtools view -@ $3 -hb $fiz -o bam_from_region_$buz/${fiz%.bam}_${buz}.bam $1 | echo bam file from region $1 created with the following name ${fiz%.bam}_${buz}.bam; done

fi

fi

# TODO: check samtools view behavior when -@ is missing. In case it works normally, don't do anything.


# to display error message when a variable is missing 
# if [[ $3 == "" ]] 
# then
# echo "Second argument (number of processors) missing"
#exit 0
#fi
