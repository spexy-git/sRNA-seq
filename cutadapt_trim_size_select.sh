#!/bin/bash

mkdir -p data/cutadapt/adapter_trimmed/18-26_size_selected
mkdir data/cutadapt/logs

# Remove adapter TGGAATTCTCGGGTGCCAAGG
for adaptini in $(ls -1 $1)

do

    cutadapt -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed -o data/cutadapt/adapter_trimmed/${adaptini%.fastq.gz}_adapter_trimmed.fastq.gz $1/$adaptini -j 0 > data/cutadapt/logs/${adaptini%.fastq.gz}_adapter_trimming.log | echo "trimming adapter TGGAATTCTCGGGTGCCAAGG from $adaptini"
done

# Remove 4 random nucleotides at both 5'and 3' and select for size range 18-26

for trimmed in $(ls -1 data/cutadapt/adapter_trimmed/*.fastq.gz | sed s/^.*\\/\//)

do
    cutadapt -u 4 -u -4 -m 18 -M 26 -o data/cutadapt/adapter_trimmed/18-26_size_selected/${trimmed%.fastq.gz}_18-26.fastq.gz data/cutadapt/adapter_trimmed/$trimmed -j 0 > data/cutadapt/logs/${trimmed%.fastq.gz}_trimming_size_selection.log | echo "selecting size range 18-26 for $trimmed"
done
