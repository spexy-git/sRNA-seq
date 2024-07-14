#!/bin/bash
# Pipeline to analyze mapped sRNA-seq directly from the mapping. If you need to perform adapter trimming or size selection, do it before running this pipeline.

#Usage there is another script called run_analyze_sRNA-seq_config.sh that runs this script and generates logs and error files. If you want to run this script just run anayze_sRNA-seq_config.sh <folder containing fastq files> <location of the genome folder> <number of processors>

# STEP 0: link to raw data

mkdir data

for files in $(ls -1 $1)
do
    ln -s $1/$files data/
done


# STEP 1: Get genome name (from configuration file inside genome folder) and run mapping on genome script

# STEP 1.1: Get genome name from the configuration file inside genome folder: If you need help in configuring genome folder read: Genome_configuration.txt in ~/Documents/Genomes)
name=$(grep -w name $2/config_pipelines_PQ/config.txt | awk '{print $2}')

# STEP 1.2: Get genome indexes location from the configuration file inside genome folder: If you need help in configuring genome folder read: Genome_configuration.txt in ~/Documents/Genomes)
indexes=$(grep Bowtie2_index_location $2/config_pipelines_PQ/config.txt | awk '{print $2}')

# STEP 1.3: Get featuure GTF file location for feature_counts
feature_counts=$(grep -w s_annotation_file $2/config_pipelines_PQ/config.txt | awk '{print $2}')

# STEP 1.4: get feature to count with feature_counts
feature_to_count=$(grep -w s_feature_to_count $2/config_pipelines_PQ/config.txt | awk '{print $2}')

# STEP 1.5: get feature to count with feature_counts
attribute_to_use=$(grep -w s_attribute_to_use $2/config_pipelines_PQ/config.txt | awk '{print $2}')

# STEP 1.6: Store configuration information in a file named run_info.txt
echo -e "Genome folder location: $2\nGenome name: $name\nGenome Indexes location: $indexes\nGTF file for featurCounts: $feature_counts\nFeature to count: $feature_to_count\nAttribute to use for feature counting: $attribute_to_use" > run_info.txt

# STEP 2: run mapping on genome script

mapping_on_genome_bowtie2.sh $1 $indexes $name $3

cd bowtie2/mapped_on_$name

# STEP 3: convert SAM to BAM

mkdir -p BAM/tmp/all
mkdir BAM/tmp/fwd_and_rev
mkdir BAM/tmp/22nt_reads

for sam in $(ls -1 *.sam)
do
    # -b option= ouput in BAM format
    samtools view -@ $3 -b $sam -o BAM/tmp/all/${sam%.sam}.bam | echo "converting $sam to BAM"
done
    echo "BAM file created and placed in the following folder: BAM/tmp/all"
    
    # Remove SAM files
    echo "Removing SAM files"
    rm -rfv *.sam

# STEP 4 separate FWD and REV reads

echo "Extracting fwd and reverse reads from BAM files"
for bamsf in $(ls -1 BAM/tmp/all/); do samtools view -h -@ $3 -F 16 -o BAM/tmp/fwd_and_rev/${bamsf%.bam}_FWD.bam BAM/tmp/all/$bamsf; done
for bamsr in $(ls -1 BAM/tmp/all/); do samtools view -h -@ $3 -f 16 -o BAM/tmp/fwd_and_rev/${bamsr%.bam}_REV.bam BAM/tmp/all/$bamsr; done

# STEP 5: extract 22nt SAM

echo "Extracting 22nt reads from BAM files"
for samsize in $(ls -1 BAM/tmp/all/); do samtools view -h -@ $3 BAM/tmp/all/$samsize | bioawk -c sam -H 'length($seq)==22' > BAM/tmp/22nt_reads/${samsize%.bam}_22nt.bam; done

# STEP 6 sort and index BAM files
	#sort
echo "Sorting and indexing BAM files"
        for folders in $(ls -1 BAM/tmp)
do
	mkdir BAM/$folders/
	for bam in $(ls -p BAM/tmp/$folders/ | egrep -v /$)
	do 
		samtools sort -@ $3 BAM/tmp/$folders/$bam -o BAM/$folders/$bam
	done
done

echo "removing unsorted BAM files"
rm -rfv BAM/tmp

	#index BAM files
for folders in $(ls -1 BAM)
do
	for bams in $(ls -p BAM/$folders/ | egrep -v /$)	
	do 
		samtools index BAM/$folders/$bams | echo "BAM file indexed for sorted_and_indexed/$bams"
	done
done

# STEP 7 compute size distribution
echo "Compute size distribution"
mkdir -p figures/size_distribution

for bammix in $(ls -1 BAM)
do
	mkdir figures/size_distribution/$bammix
	mkdir figures/size_distribution/$bammix/tmp
	mkdir figures/size_distribution/$bammix/raw_data

	# compute size distribution for all the *.bam files in the folder and place them in the folder created before size_distribution/tmp. The files are only temporary since they need to be processed.
for size in $(ls -1 BAM/$bammix/ | grep -v /$ | grep -v /*.bai); do samtools view -@ $3 BAM/$bammix/$size | bioawk -c sam '{hist[length($seq)]++} END {for (l in hist) print l, hist[l]}' | sort -n -k1 > figures/size_distribution/$bammix/tmp/${size%.bam}_size_distribution.txt; done

	# Insert the name of the columns in the table generated before. 
for numbers in $(ls -1 figures/size_distribution/$bammix/tmp/); do echo -e "size\tnumber_of_reads" | cat - figures/size_distribution/$bammix/tmp/$numbers > figures/size_distribution/$bammix/raw_data/$numbers; done

	# remove original temporary files
rm -rfv figures/size_distribution/$bammix/tmp

	# create graph using R

for cri in $(ls figures/size_distribution/$bammix/raw_data/); do generate_barplot_for_size_distribution.r figures/size_distribution/$bammix/raw_data/$cri figures/size_distribution/$bammix/${cri%.txt}.pdf; done

pdfunite figures/size_distribution/$bammix/*.pdf figures/size_distribution/$bammix/all.pdf
done

# STEP 8 Perform featureCounts based on the configuration file

# STEP 8.1: test if a feature to count is defined in the configuration file. If the variable feature_counts is defined, the pipeline will compute feature counts on the feature listed in the configuration file, otherwise it will display a message that will be stored in the log file.
if [ -z "$feature_counts" ]
then
    echo "Feature_counts not performed"
else
    
    mkdir featureCounts

    # Count all reads (-s 0)
    
    for count in $(ls -1 BAM/all/ | egrep -v *.bai); do featureCounts -s 0 -a $feature_counts -o featureCounts/${count%.bam}_all_counts.txt -t $feature_to_count -g $attribute_to_use -O -M --primary -T $3 BAM/all/$count; done

    featureCounts -s 0 -a $feature_counts -o featureCounts/all_sample_all_counts.txt -t $feature_to_count -g $attribute_to_use -O -M --primary -T $3 BAM/all/*.bam


    # Coiunt sense reads (-s 1)
    
    for count in $(ls -1 BAM/all/ | egrep -v *.bai); do featureCounts -s 1 -a $feature_counts -o featureCounts/${count%.bam}_SENSE_counts.txt -t $feature_to_count -g $attribute_to_use -O -M --primary -T $3 BAM/all/$count; done

    featureCounts -s 1 -a $feature_counts -o featureCounts/all_sample_SENSE_counts.txt -t $feature_to_count -g $attribute_to_use -O -M --primary -T $3 BAM/all/*.bam


    # Coiunt sense reads (-s 2)
    
    for count in $(ls -1 BAM/all/ | egrep -v *.bai); do featureCounts -s 2 -a $feature_counts -o featureCounts/${count%.bam}_ANTIsense_counts.txt -t $feature_to_count -g $attribute_to_use -O -M --primary -T $3 BAM/all/$count; done

    featureCounts -s 2 -a $feature_counts -o featureCounts/all_sample_ANTIsense_counts.txt -t $feature_to_count -g $attribute_to_use -O -M --primary -T $3 BAM/all/*.bam

    # STEP 7 compute RPM

cd featureCounts

for files in $(ls -1 all_sample_*_counts.txt)
do
    RPM_on_feature_counts.sh $files ${files%counts.txt}RPM.txt
done

cd ../

fi
# STEP 8 make bw
	#Not normalized
echo "Generating un-normalized bigwig"
        for folders in $(ls -1 BAM)
do
	mkdir -p bigwig/$folders
	mkdir bigwig/$folders/logs
	mkdir bigwig/$folders/NOT_normalized
	for btbw in $(ls -p BAM/$folders/ | grep -v /$ | grep -v /*.bai)
	do
		bamCoverage -bs 20 -p $3 -v -b BAM/$folders/$btbw -o bigwig/$folders/NOT_normalized/${btbw%.bam}.bw 2> bigwig/$folders/logs/${btbw%.bam}.log
	done
done

	#Normalized on CPM
echo "Generating normalized bigwig. Normalization: CPM"
        for folders in $(ls -1 BAM)
do
	mkdir bigwig/$folders/Normalized_by_CPM
	for bwcpm in $(ls -p BAM/$folders | grep -v /$ | grep -v /*.bai)
	do
		bamCoverage -bs 20 -p $3 --normalizeUsing CPM -v -b BAM/$folders/$bwcpm -o bigwig/$folders/Normalized_by_CPM/${bwcpm%.bam}_by_CPM.bw 2> bigwig/$folders/logs/${bwcpm%.bam}_by_CPM.log
	done
done

echo "Analysis finished. Check .err file for possilble errors."
