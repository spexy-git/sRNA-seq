#!/bin/bash
# $1=location of fastq files $2=location of genome with basename of the indexes file (everything before the dot (.1.bt2) $3 genome to use (only for name)
# the script doesn't create folders so you need to create the folders before running the scripr
# usage: mapping_on_genome.sh <folder containing fastq files> <location of genome indexes including basename of indexes> <name of the genome in use> <number of processors>


# Display help file with --help option

if [[ $1 == "--help" ]]
then
echo "mapping on genome using bowtie2 --seed 123 -t -L 6 -i S,1,0.8 -N 0 --mm 

	usage: mapping_on_genome.sh <folder containing fastq files> <location of genome indexes including basename of indexes> <name of the genome in use> <number of processors>"
# TODO write the command executed from the script
else


genome=$3
mkdir bowtie2
cd bowtie2
mkdir mapped_on_$3 not_mapped_on_$3 logs_mapping_on_$3

echo "I am using $3 genome"

for input in $(ls $1); do bowtie2 -p $4 --seed 123 -t -L 6 -i S,1,0.8 -N 0 --mm -x $2 -U $1/$input --no-unal --un-gz not_mapped_on_$3/${input%.fastq.gz}_not_mapped_on_$3.fastq.gz -S mapped_on_$3/${input%.fastq.gz}_mapped_on_$3.sam 2> logs_mapping_on_$3/${input%.fastq.gz}_mapping.log | echo mapping $input on $3 genome using $4 threads; done

echo done

fi
