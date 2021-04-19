#!/usr/bin/env bash

### BBDuk adapter and quality trimming (adjust parameters as necessary)

bbduk_main(){
	
	bbduk_trim

}

bbduk_trim(){

cd ${ANALYSIS_FOLDER}
mkdir -p ${ANALYSIS_FOLDER}/bbduk_trimmed_reads
rawdatalist=$(ls -d $RAWDATA_FOLDER/*_R1_*.fastq.gz | awk '{print $NF}') #could also use find

for read in ${rawdatalist}
do

read2=${read/_R1_001.fastq.gz/_R2_001.fastq.gz}
fname=$(basename ${read} | sed -e "s/_R1_001.fastq.gz//") #strip extension
echo "Running bbduk on sample ${fname}"

bbduk.sh in1=${read} in2=${read2} out1=bbduk_trimmed_reads/${fname}_cleaned_1.fastq.gz out2=bbduk_trimmed_reads/${fname}_cleaned_2.fastq.gz ref=${DOCS_FOLDER}/BBDUK_adapters/adapters.fa ktrim=r k=21 mink=10 hdist=2 qtrim=r trimq=25 minlen=100 t=7

# ref=/Users/martingordon/src_git/bbmap/resources/adapters.fa #this works
done 

}

bbduk_main