#!/bin/bash
# Sort bam file. This is not the same of sorting fwd and reverse. This sorting step is needed in order to index bam files.
# Usage: from the folder with the .bam files run sort_bam.sh <number of cores>

mkdir sorted_and_indexed

for bam in $(ls *.bam); do samtools sort -@ $1 $bam -o sorted_and_indexed/$bam | echo "BAM file sorted for $bam and placed in the following folder: sorted_and_indexed"; done

cd sorted_and_indexed

for sor in $(ls *.bam); do samtools index $sor | echo "BAM file indexed for sorted_and_indexed/$sor"; done



