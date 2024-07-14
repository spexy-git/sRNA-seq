#!/bin/bash
# Script to run the script analyze_mapped_sRNA.sh and create logs and display at the same time.
#Usage analyze_mapped_sRNA.sh <number of processors>


if [[ $1 == "--help" ]]
then
echo "Run pipeline to analyze sRNA-seq data starting from mapping. It doesn't perform size selection and deduplication. To use with data that have been already trimmed.

The script uploads the parental folder at /pasteur/projets/policy02/RNAEPIGEN/pquarato/Data_analysis/sRNA-seq/

	usage: run_analyze_sRNA.sh <folder containing fastq files> <location of genome folder> <number of processors>"
# TODO write the command executed from the script
else
    time=$(date +"%d%m%y_%Ra" | tr : h | tr a m)
analyze_sRNA-seq_config.sh $1 $2 $3 2> analysis_$time.err | tee analysis_$time.log

destination=$(echo ${PWD##*/})

rsync -vaP ../$destination pquarato@tars:/pasteur/projets/policy02/RNAEPIGEN/pquarato/Data_analysis/sRNA-seq/

echo "Analysis finished" | mailx -s "sRNA-seq pipeline completed" piergiuseppe.quarato@gmail.com

fi
