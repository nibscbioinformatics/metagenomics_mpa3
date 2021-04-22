#!/usr/bin/env bash

### metaphlan run

# Estimate relative abundance of microbes by mapping reads against a set of clade-specific marker sequences (number of cells rather than read fraction)




metaphlan_main(){
	
	run_metaphlan
	merge_tables
	#cleanup_tmp #leave out for now

}

run_metaphlan(){

echo "Running Metaphlan"

# link reference to folders in $ROOT

mkdir -p ${REFERENCE_FOLDER}/reference_database/
ln -s ${LINKPATH_DB}/reference_database/metaphlan3 ${REFERENCE_FOLDER}/reference_database/ #create sym link

mkdir -p ${ANALYSIS_FOLDER}/metaphlan
mkdir -p ${ANALYSIS_FOLDER}/metaphlan/profiles
mkdir -p ${ANALYSIS_FOLDER}/metaphlan/merged_table
cd ${ANALYSIS_FOLDER}/metaphlan

inputdatalist=$(ls -d ${ANALYSIS_FOLDER}/seqtk_output/combined* | awk '{print $NF}')

for read in ${inputdatalist}
do

fname=$(basename ${read} | sed -e "s/_1.fastq.gz//") 
echo "Running metaphlan on sample ${fname}"

 #combined fastq file input .. produces text file of sample taxonomic profile
 #path to indexed database, bowtie2 installation
 #nomap = dont save intermediate bowtie2 output(created with prepare_metaphlan.sh)
 #use the mpa_v30_CHOCOPhlAn_201901 database version

metaphlan ${read} --input_type fastq --no_map --index mpa_v30_CHOCOPhlAn_201901 --bowtie2db ${REFERENCE_FOLDER}/reference_database/metaphlan3 --bowtie2_exe ${LINKPATH_DB}/tmp/bowtie2-2.4.2-linux-x86_64/bowtie2 -o ${ANALYSIS_FOLDER}/metaphlan/profiles/${fname}_profile.txt 
done

}


merge_tables(){

echo "Merging Metaphlan Output...."
#merge the taxonomic profiles for all samples 
merge_metaphlan_tables.py ${ANALYSIS_FOLDER}/metaphlan/profiles/* > ${ANALYSIS_FOLDER}/metaphlan/merged_table/merged_table.txt

}

#cleanup bowtie2 installation
#have not included... don't want to remove incase of run errors..
# if 0 exit status, run this?

cleanup_tmp(){

   if [ -d "${LINKPATH_DB}/tmp" ]; then
      rm -r ${LINKPATH_DB}/tmp 
   fi

}

#run the processes
metaphlan_main

