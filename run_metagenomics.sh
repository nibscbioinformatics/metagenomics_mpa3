#!/usr/bin/env bash


### Workflow for shotgun metagenomics analysis

## Root folder name
NAME=nibsc_metagenomics

echo "Please Check File Paths in run_metagenomics.sh"

## data file locations
READS='/Users/martingordon/Desktop/metaphlan_prac/data/' #change path to you data directory... use $1?
LINKPATH_DB=/Users/martingordon/Desktop/metagenomics_mpa3/reference #change path
# ADAPTERs='/Users/martingordon/src_git/bbmap/resources/adapters.fa' dont need this 


## metagenomics analysis workflow - comment out to remove process

metagenomics_analysis_main(){
   create_folders 
   set_variables # -> Never comment this function
   #fetch_example_data # -> Uncomment this function if you want to run pipeline on test data
   copy_rawdata 
   run_bbduk 
   run_seqtk
   run_metaphlan
   echo $LINKPATH_DB
}


create_folders(){

   echo "Creating sub-folders..."

   # Sub-folders in the root folder
   for FOLDER in analysis tools rawdata scripts docs reference
   do
      mkdir -p ${NAME}/${FOLDER}
   done
   echo "DONE creating sub-folders!"
}


# setting variable path
set_variables(){
   echo "Setting variables for paths..."

   export ROOT_FOLDER_NAME=${NAME}
   export TOOLS_FOLDER=$(pwd)/$ROOT_FOLDER_NAME/tools
   export RAWDATA_FOLDER=$(pwd)/$ROOT_FOLDER_NAME/rawdata
   export ANALYSIS_FOLDER=$(pwd)/$ROOT_FOLDER_NAME/analysis
   export REFERENCE_FOLDER=$(pwd)/$ROOT_FOLDER_NAME/reference
   export DOCS_FOLDER=$(pwd)//$ROOT_FOLDER_NAME/docs
   export SCRIPT_FOLDER=$(pwd)//$ROOT_FOLDER_NAME/scripts
   export LINKPATH_DB=$LINKPATH_DB
   echo "DONE setting variables for paths!"

   #soft link files
   #include links for scripts and tools (maybe just cat *.yml > software_list.txt) under ROOTDIR script & tools folder?
   echo "Ordering Folders"
   mkdir -p ${DOCS_FOLDER}/BBDUK_adapters
   ln -s $(pwd)/adapters.fa ${DOCS_FOLDER}/BBDUK_adapters/
}

# copy raw data from source folder to analysis folder structure

copy_rawdata(){

   lst=$(ls -d ${READS}/*.fastq.gz)
   for file in $lst
   do
      echo "Copying ${file}"
      cp ${file} ${RAWDATA_FOLDER}/
   done
   echo "DONE copying rawdata!"
}

# run pipeline using test data (uncomment above)
# paired reads from Chrysi exp used for testing

fetch_example_data(){

   mkdir -p $NAME/example_data

   cd $NAME/example_data

   wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR114/039/SRR11487939/SRR11487939_1.fastq.gz
   wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR114/039/SRR11487939/SRR11487939_2.fastq.gz

   SRC_RAWDATA=$NAME/example_data
   cd -
}

# Run bbduk adapter & quality trimming

run_bbduk(){
   echo "Running BBDuk Adapter & Quality Trimming"

   . ./run_bbduk.sh

   echo "DONE Trimming!"
   cd -

}

# Run seqtk subsampling & merging

run_seqtk(){
   echo "Running Seqtk Subsampling & Read Merging"

   . ./run_seqtk.sh

   echo "DONE Subsampling & Merging!"
   cd -
}

#  Run metaphlan3 taxonomic classification (first run prepare_metaphlandb.sh !)

run_metaphlan(){
   echo "Running Metaphlan3 Taxonomic Classification"

   . ./run_metaphlan.sh

   echo "DONE Metaphlan3 Taxonomic Classification!"
}


# run pipeline

metagenomics_analysis_main
