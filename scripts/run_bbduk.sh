#!/usr/bin/env bash

## BBDuk adapter and quality trimming (adjust parameters as necessary)

# Adapter trimming - Identify 21-mer matches between fastq and adapter sequences - trims adapters from 3’ end 
# hdist=2 two mismatches tolerated, minlen >= 100bp, 25 phred score threshold, multithreading (7 threads), sequences 20-mer...10mer in length at 3’ ends also searched and trimmed
# Rev complement searched for by default

bbduk_main(){
	
	bbduk_trim

}

bbduk_trim(){

cd ${ANALYSIS_FOLDER}
mkdir -p ${ANALYSIS_FOLDER}/bbduk_trimmed_reads
rawdatalist=$(ls -d $RAWDATA_FOLDER/*.fastq.gz | awk '{print $NF}') 

for read in ${rawdatalist}
do

# fastq extension format - if not '*_R*_001.fastq' modify the 2 lines below
read2=${read/_R1_001.fastq.gz/_R2_001.fastq.gz} # if your data does not follow "_R*_001.fastq.gz" naming convention, please change (eg read2=${read/_1.fastq.gz/_2.fastq.gz})
fname=$(basename ${read} | sed -e "s/_R1_001.fastq.gz//") #as above (eg fname=$(basename ${read} | sed -e "s/_1.fastq.gz//"))

bbduk.sh -Xmx128g in1=${read} in2=${read2} \
 out1=bbduk_trimmed_reads/${fname}_cleaned_1.fastq.gz out2=bbduk_trimmed_reads/${fname}_cleaned_2.fastq.gz \
 ref=${DOCS_FOLDER}/BBDUK_adapters/adapters.fa \
 ktrim=r k=21 mink=10 hdist=2 qtrim=r trimq=25 minlen=100 t=7 tpe tbo >>bbduk_trimmed_reads/bbduklog.txt 2>&1  

done 

}

bbduk_main
