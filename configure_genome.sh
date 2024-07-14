#!/bin/bash

# Pipeline to configure a genome folder starting from a fasta file. Run from anywhere.

#Usage: configure_genome.sh <genome folder destination> <location of fasta file> <basename for indexes> <name of the genome> <number of threads>
# Suggestion: when you create a genome folder, also keep the information regarding the database used and the version of the genome. Example: Documents/Genome/Caenorabditis_elegans/Ensembl/Wbcel235/......


# Display help file with --help option

if [[ $1 == "--help" ]]
then
    echo "Pipeline to configure a genome folder starting from a fasta file. Run from anywhere.

    Usage: configure_genome.sh <genome folder destination> <location of fasta file> <basename for indexes> <name of the genome> <number of threads>

    Suggestion: when you create a genome folder, also keep the information regarding the database used and the version of the genome. Example: Documents/Genome/Caenorabditis_elegans/Ensembl/Wbcel235/......"

else

    # STEP 1 Create main subfolders ($1 = genome folder)
    mkdir -p $1/Sequence
    mkdir -p $1/Annotation
    mkdir -p $1/config_pipelines_PQ
    cd $1

    # Step 2 Create indexes subfolders
    mkdir -p Sequence/Indexes/hisat2Index
    mkdir -p Sequence/Indexes/Bowtie2Index

    # Step 3 Copy genome fasta file to Sequence folder ($2 = location of fasta file)
    cp $2 Sequence/

    # Step 4 Create indexes for bowtie2 and hisat2 ($2 = location of fasta file, $3 = basename for indexes, $4 = numbef of threads)
    cd Sequence/Indexes/Bowtie2Index
    bowtie2-build $2 $3 --threads $5
    bowtie2_indexes=$(echo ${PWD})
    cd ../../../
    
    cd Sequence/Indexes/hisat2Index
    hisat2-build $2 $3 -p $5
    hisat2_indexes=$(echo ${PWD})
    cd ../../../

    echo "name>---$4
Bowtie2_index_location>-$bowtie2_indexes/$3
hisat2_index_location>--$hisat2_indexes/$3" > config_pipelines_PQ/config.txt
fi
