#!/usr/bin/env bash

## BBDuk adapter and quality trimming (adjust parameters as necessary)

# Adapter trimming - Identify 21-mer matches between fastq and adapter sequences - trims adapters from 3’ end 
# Rev complement searched for by default



bbduk_main(){
	
	bbduk_trim

}

bbduk_trim(){

cd ${ANALYSIS_FOLDER}
mkdir -p ${ANALYSIS_FOLDER}/bbduk_trimmed_reads
rawdatalist=$(ls -d $RAWDATA_FOLDER/*_R1_*.fastq.gz | awk '{print $NF}') 

for read in ${rawdatalist}
do

read2=${read/_R1_001.fastq.gz/_R2_001.fastq.gz}
fname=$(basename ${read} | sed -e "s/_R1_001.fastq.gz//") #strip extension
echo "Running bbduk on sample ${fname}"

bbduk.sh in1=${read} in2=${read2} \
 out1=bbduk_trimmed_reads/${fname}_cleaned_1.fastq.gz out2=bbduk_trimmed_reads/${fname}_cleaned_2.fastq.gz \
 ref=${DOCS_FOLDER}/BBDUK_adapters/adapters.fa \
 ktrim=r k=21 mink=10 hdist=2 qtrim=r trimq=25 minlen=100 t=7  # hdist=2 two mismatches tolerated, minlen >= 100bp, 25 phred score threshold, multithreading (7 threads), sequences 20-mer...10mer in length at 3’ ends also searched and trimmed

done 

}

bbduk_main
