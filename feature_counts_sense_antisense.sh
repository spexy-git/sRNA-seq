#!/bin/bash
#Perform featureCounts on all the sam file in the run folder. It produces 1 file per sample and a file with all the samples. It produces all, SENSE and ANTIsense counts.
#usage feature_counts.sh <location of gtf file> <feature to count from gtf file (example miRNA)> <attribute to use (geneid, name...see gtf file, default is gene id)> <number of threads>

# Display help file with --help option

if [[ $1 == "--help" ]]
then
	echo "Count feature from gtf file using featureCounts (http://gensoft.pasteur.fr/docs/subread/1.4.6-p3/SubreadUsersGuide.pdf). The script creates a folder called featureCounts and places the files there.
	usage feature_counts.sh <location of gtf file> <feature to count from gtf file (example miRNA)> <attribute to use (geneid, name...see gtf file, default is gene id)> <number of threads>"

# TODO write the command executed from the script

else

mkdir featureCounts

    # Count all reads (-s 0)
    
    for count in *.*am; do featureCounts -s 0 -a $1 -o featureCounts/${count%.*am}_all_counts.txt -t $2 -g $3 -O -M --primary -T $4 $count; done

    featureCounts -s 0 -a $1 -o featureCounts/all_sample_all_counts.txt -t $2 -g $3 -O -M --primary -T $4 *.*am


    # Coiunt sense reads (-s 1)
    
    for count in *.*am; do featureCounts -s 1 -a $1 -o featureCounts/${count%.*am}_SENSE_counts.txt -t $2 -g $3 -O -M --primary -T $4 $count; done

    featureCounts -s 1 -a $1 -o featureCounts/all_sample_SENSE_counts.txt -t $2 -g $3 -O -M --primary -T $4 *.*am


    # Coiunt sense reads (-s 2)
    
    for count in *.*am; do featureCounts -s 2 -a $1 -o featureCounts/${count%.*am}_ANTIsense_counts.txt -t $2 -g $3 -O -M --primary -T $4 $count; done

    featureCounts -s 2 -a $1 -o featureCounts/all_sample_ANTIsense_counts.txt -t $2 -g $3 -O -M --primary -T $4 *.*am

fi
