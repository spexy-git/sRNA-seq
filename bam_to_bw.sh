#!/bin/bash
# The script create bw files from bam files. The bam needs to be in the same folder where you run the script together with index files. If you need to sort and index bam files run script sort_bam.sh
# Usage bam_to_bw.sh <number of threads>

# Display help file with --help option

if [[ $1 == "--help" ]]
then
    echo "Creates bw files from all *.bam files in the folder. Output files are placed in the new directory bw and the logs in thw new directory bw/logs.
    
    USAGE bam_to_bw.sh <number of threads>"
# TODO write the command executed from the script
else

mkdir bw
mkdir bw/logs

for btbw in $(ls *.bam); do bamCoverage -bs 20 -p $1 -v -b $btbw -o bw/${btbw%.bam}.bw 2> bw/logs/${btbw%.bam}.log ; done
fi
