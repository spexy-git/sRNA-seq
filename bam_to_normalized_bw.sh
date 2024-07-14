#!/bin/bash
# The script create bw files from bam files. The bam needs to be in the same folder where you run the script together with index files. If you need to sort and index bam files run script sort_bam.sh
# Usage: bam_to_normalized_bw <normalization (Possible choices: RPKM, CPM, BPM, RPGC, None> <number of processors>


# Display help file with --help option

if [[ $1 == "--help" ]]
then
echo "Script to run bamCoverage that generates normalized bigwig from sorted and indexed BAM files. 
Usage:
bam_to_normalized_bw <normalization (Possible choices: RPKM, CPM, BPM, RPGC, None> <number of processors>"
# TODO write the command executed from the script
else


mkdir bw_normalized_by_$1
mkdir bw_normalized_by_$1/logs

for btbw in $(ls *.bam); do bamCoverage -bs 20 -p $2 --normalizeUsing $1 -v -b $btbw -o bw_normalized_by_$1/${btbw%.bam}.bw 2> bw_normalized_by_$1/logs/${btbw%.bam}.log ; done

fi
