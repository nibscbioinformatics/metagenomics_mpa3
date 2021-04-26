#!/usr/bin/env bash

### Read subsampling (500k) & file merging (adjust parameters as necessary)

# Reads are subsampled to 250,000 per file and combined 
# -S option NB to keep same for both strands to preserve read pairing 

seqtk_main(){

	seqtk_subsampling
}


seqtk_subsampling(){


cd ${ANALYSIS_FOLDER}
mkdir -p ${ANALYSIS_FOLDER}/seqtk_output
trimdatalist=$(ls -d ${ANALYSIS_FOLDER}/bbduk_trimmed_reads/*_cleaned_1.fastq.gz | awk '{print $NF}') 

for read in ${trimdatalist}
do
#echo $read
read2=${read/_cleaned_1.fastq.gz/_cleaned_2.fastq.gz}
#echo $read2
fname=$(basename ${read} | sed -e "s/_cleaned_1.fastq.gz//") #strip path and extension
#echo $fname
echo "Running seqtk subsamping (500k) & merging on sample ${fname}"

seqtk sample -s100 ${read} 250000 > seqtk_output/${fname}_250K_1.fastq.gz
seqtk sample -s100 ${read2} 250000 > seqtk_output/${fname}_250K_2.fastq.gz
cat  seqtk_output/${fname}_250K_1.fastq.gz seqtk_output/${fname}_250K_2.fastq.gz > seqtk_output/combined_${fname}_500K.fastq.qz

done 

}

seqtk_main
