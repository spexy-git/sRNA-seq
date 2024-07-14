#!/bin/bash
# The script extracts and separates forward and reverse reads from a bam file and put them in two different files with the suffix FWD or REV. It acts on all BAM files of the folder.
# Usage: from the folder with the sam file run bam_to_fwd_rev_bam.sh <number of threads>

# Display help file with --help option

if [[ $1 == "--help" ]]
then
    echo "Extracts FWD amd REV reads from all *.bam files in the folder and creates two separated files. Output files are placed in the new folder fwd_rev_bam
    
    USAGE: bam_to_fwd_rev_bam.sh <number of threads>"
# TODO write the command executed from the script
else
mkdir fwd_rev_bam

for bamsf in $(ls *.bam); do samtools view -@ $1 -F 16 -o fwd_rev_bam/${bamsf%.bam}_FWD.bam $bamsf; done
for bamsr in $(ls *.bam); do samtools view -@ $1 -f 16 -o fwd_rev_bam/${bamsr%.bam}_REV.bam $bamsr; done
fi
