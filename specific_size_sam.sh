#!/bin/bash

if [[ $1 == "--help" ]]
then
    echo "Ëxtract reads of a certain size from all SAM files in a directory using bioawk.
    This script creates a directory named xnt_SAM and places all the output files there
    
    USAGE: specific_size_sam.sh <size in nucleotides>"
# TODO write the command executed from the script
else

    #Create SAM files of specified nucleotides length

mkdir $1nt_SAM

for samsize in $(ls *.sam); do bioawk -v VAR=$1 -c sam -H 'length($seq)==VAR' $samsize > 22nt_SAM/${samsize%.sam}_22nt.sam; done
fi
