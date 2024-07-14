#!/bin/bash
# Use to perform featureCounts on all SAM or BAM files included in different subfolders. Run from parent directory.. It works if sam files from different categories are placed in a folder that contains only one folder per category. example: if you have 22nt_sam files and all_sam they need to be placed in the following order: FOLDER/all and FOLDER 22nt. 
#usage feature_counts.sh <location of folders containing sam files. In the folder there need to be no additional files, only the folders containing different categories of sam files> <destination of featureCounts folder> <location of gtf file> <feature to count from gtf file (example miRNA)> <attribute to use (geneid, name...see gtf file, default is gene id)> <number of cores>

# Display help file with --help option

if [[ $1 == "--help" ]]
then
echo "usage feature_counts.sh <location of folders containing sam files. In the folder there need to be no additional files, only the folders containing different categories of sam files> <destination of featureCounts folder> <location of gtf file> <feature to count from gtf file (example miRNA)> <attribute to use (geneid, name...see gtf file, default is gene id)> <number of threads>"

# TODO write the command executed from the script
else

	mkdir $2

	for cartelle in $(ls -1 $1)
	do
		mkdir $2/$cartelle
		for map in $(ls -1 $1/$cartelle/)
		do
			featureCounts -a $3 -o $2/$cartelle/${map%.sam}_counts.txt -O -M -t $4 -g $5 --primary -T $6 $1/$cartelle/$map
		done

		featureCounts -a $3 -o $2/$cartelle/all_sample_${cartelle}_counts.txt -O -M -t $4 -g $5 --primary -T $6 $1/$cartelle/*.sam
	done

fi








#mkdir featureCounts

#for count in *.sam; do featureCounts -a $1 -o featureCounts/${count%.sam}_counts.txt -t $2 -g $3 -O -M --primary -T $4 $count; done

#featureCounts -a $1 -o featureCounts/all_sample_counts.txt -t $2 -g $3 -O -M --primary -T $4 *.sam

#fi
