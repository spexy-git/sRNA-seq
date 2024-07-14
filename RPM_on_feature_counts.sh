#!/bin/bash
#Script to compute RPM using an R_script. Launch from the directory with counts data.

# Display help file with --help option

if [[ $1 == "--help" ]]
then

    echo "Script to computer the RPM on counts data from fetureCounts. The Input file should have the following columns: gene_name, col2, col3, col4, col5, col6, counts(n columns). Columns 2 to 6 will be deleted from the script that will ouput a file with: gene_name, RPM_sample1, RPM_sample2, ..., RPM_sample_n.
	Usage:
        RPM_on_featureCounts.sh <count_table (tab_separated)> <output_name>"


else
	
	compute_RPM_on_featureCounts.r $1 $2
fi
