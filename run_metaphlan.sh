#!/usr/bin/env bash

### metaphlan run


metaphlan_main(){
	
        activate_conda_env
	run_metaphlan
	merge_tables
	cleanup_tmp #get running

}

activate_conda_env(){
	
        eval "$(conda shell.bash hook)"
	conda activate metaphlan3

}

run_metaphlan(){

echo "Running Metaphlan"

# prob more elegant solutions, but wanted to preserve directory structure.. 
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
#metaphlan ${read} --input_type fastq --no_map --index mpa_v30_CHOCOPhlAn_201901 --bowtie2db ${REFERENCE_FOLDER}/reference_database/metaphlan3 --bowtie2_exe ${LINKPATH_DB}/tmp/bowtie2-2.4.2-macos-x86_64/bowtie2  -o  ${ANALYSIS_FOLDER}/metaphlan/profiles/${fname}_profile.txt
#HPC command below - comment out above line for HPC deployment
metaphlan ${read} --input_type fastq --no_map --index mpa_v30_CHOCOPhlAn_201901 --bowtie2db ${REFERENCE_FOLDER}/reference_database/metaphlan3 --bowtie2_exe ${LINKPATH_DB}/tmp/bowtie2-2.4.2-linux-x86_64/bowtie2  -o  ${ANALYSIS_FOLDER}/metaphlan/profiles/${fname}_profile.txt
done

}


merge_tables(){

echo "Merging Metaphlan Output...."
merge_metaphlan_tables.py ${ANALYSIS_FOLDER}/metaphlan/profiles/* > ${ANALYSIS_FOLDER}/metaphlan/merged_table/merged_table.txt

}

#cleanup bowtie2 installation

cleanup_tmp(){

   if [ -d "${LINKPATH_DB}/tmp" ]; then
      rm -r ${LINKPATH_DB}/tmp 
   fi

}

#run the processes
metaphlan_main

