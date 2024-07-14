#!/bin/bash
#Perform featureCounts on all the sam file in the run folder. It produces 1 file per sample and a file with all the samples.
#usage feature_counts.sh <location of gtf file> <feature to count from gtf file (example miRNA)> <attribute to use (geneid, name...see gtf file, default is gene id)> <number of threads>

# Display help file with --help option

if [[ $1 == "--help" ]]
then
	echo "Count feature from gtf file using featureCounts (http://gensoft.pasteur.fr/docs/subread/1.4.6-p3/SubreadUsersGuide.pdf).
        This script performs featureCount analysis on all *.sam files in the folder. Output counts file are placed in the new directory featureCounts
	usage feature_counts.sh <location of gtf file> <feature to count from gtf file (example miRNA)> <attribute to use (geneid, name...see gtf file, default is gene id)> <number of threads>"

# TODO write the command executed from the script
else

mkdir featureCounts

for count in *.sam; do featureCounts -a $1 -o featureCounts/${count%.sam}_counts.txt -t $2 -g $3 -O -M --primary -T $4 $count; done

featureCounts -a $1 -o featureCounts/all_sample_counts.txt -t $2 -g $3 -O -M --primary -T $4 *.sam

fi
