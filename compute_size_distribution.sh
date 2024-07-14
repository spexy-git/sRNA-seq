#!/bin/bash

#Extract read size from sam
# Usage: run compute_size_distribution.sh 

#make directories needed for running the script
mkdir size_distribution
mkdir size_distribution/tmp
mkdir size_distribution/figures
echo "Computing size distribution"
#TODO multiplex https://www.unix.com/shell-programming-and-scripting/184491-multi-thread-awk-command-faster-performance.html
# compute size distribution for all the *.sam files in the folder and place them in the folder created before size_distribution/tmp. The files are only temporary since they need to be processed.
for size in $(ls *.sam); do bioawk -c sam '{hist[length($seq)]++} END {for (l in hist) print l, hist[l]}' $size | sort -n -k1 > size_distribution/tmp/${size%.sam}_size_distribution.txt; done

cd size_distribution/tmp

# Insert the name of the columns in the tabla generated before. 
for numbers in $(ls *.txt); do echo -e "size\tnumber_of_reads" | cat - $numbers > ../$numbers; done

# remove original temporary files
rm -rfv ../tmp

cd ..

# create graph using R

for cri in $(ls *.txt); do generate_barplot_for_size_distribution.r $cri figures/${cri%.txt}.pdf; done

pdfunite figures/*.pdf figures/all.pdf
