#!/bin/bash


if [[ $1 == "--help" ]]
then
    echo "Script to create a bigwig file from a bam file using bamCoverage and normalize with a provided scaling factor.
    
    Usage: bam_to_scaled_bw.sh <BAM file> <scale Factor> <output folder> <log output folder> <number of cpu>"
    # TODO write the command executed from the script

else
    bamCoverage -bs 20 -p $5 -v --scaleFactor $2 -b $1 -o $3/${1%.bam}_scaled.bw 2> $4/${1%.bam}_scaled.log
fi
