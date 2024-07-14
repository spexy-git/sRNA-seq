#!/bin/bash

# Script to perform adapter trimming and size selection (18-26) and run sRNA pipeline (analyze_sRNA-seq_config.sh).

if [[ $1 == "--help" ]]
then
    echo "Perform trim and size selection (18-26) on sRNA-seq data and run pipeline sRNA-seq_config.sh.
    The script uploads the parental folder at /pasteur/projets/policy02/RNAEPIGEN/pquarato/Data_analysis/sRNA-seq/
    usage: run_analyze_sRNA-seq_raw_config.sh <folder containing raw fastq files> <location of genome folder> <number of processors>"

else

    #link raw data
    mkdir -p data/original_data
    for files in $(ls -1 $1)
    do
        ln -s $1/$files data/original_data/
    done

    #run cutadapt script to trim adapter sequence and perform size selection
    cutadapt_trim_size_select.sh $1

    # Define location of size selected data after cutadapt step
    location=$(echo $PWD)
    input_sRNA_pipeline=$(echo $location/data/cutadapt/adapter_trimmed/18-26_size_selected)

    #run sRNA-seq_config pipeline on trimmed data
    run_analyze_sRNA-seq_config.sh $input_sRNA_pipeline $2 $3

fi
