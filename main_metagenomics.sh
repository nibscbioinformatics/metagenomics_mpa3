#!/usr/bin/env bash

### Workflow for shotgun metagenomics 16S taxonomic classification

## Root folder name
NAME=nibsc_metagenomics

echo "Please ensure READS and LINKPATH filepaths ar correct in main_metagenomics.sh"

## data file locations
READS='/home/AD/mgordon/PROJECTS/Microbiome_Project/test/testdata/shotgun_data' # change full path your data directory
LINKPATH_DB='/home/AD/mgordon/PROJECTS/Microbiome_Project/test/metagenomics_mpa3/reference' # change path to LINKPATH provided by `prepare_metaphlan.sh` output
 
## metagenomics analysis workflow - comment out to remove process

metagenomics_analysis_main(){
   
   create_folders 
   set_variables # -> Never comment this function
#  test_data # -> Remove '#' before `test_data` to testrun pipeline. Restore '#' to run with your data
   run_bbduk 
   run_seqtk
   run_metaphlan
   echo $LINKPATH_DB
}


create_folders(){

   echo "Creating sub-folders..."

   # Sub-folders in the root folder
   for FOLDER in analysis rawdata docs reference
   do
      mkdir -p ${NAME}/${FOLDER}
   done
   echo "DONE creating sub-folders!"
}


# setting variable path
set_variables(){
   echo "Setting variables for paths..."

   export ROOT_FOLDER_NAME=${NAME}
   export RAWDATA_FOLDER=$(pwd)/${ROOT_FOLDER_NAME}/rawdata
   export ANALYSIS_FOLDER=$(pwd)/${ROOT_FOLDER_NAME}/analysis
   export REFERENCE_FOLDER=$(pwd)/${ROOT_FOLDER_NAME}/reference
   export DOCS_FOLDER=$(pwd)//${ROOT_FOLDER_NAME}/docs
   export LINKPATH_DB=${LINKPATH_DB}
   echo "DONE setting variables for paths!"

   #soft link files (puts all relevant files under $ROOT_FOLDER_NAME directory)
   echo "Lnking Folders"
   mkdir -p ${DOCS_FOLDER}/BBDUK_adapters
   ln -fs $(pwd)/docs/adapters.fa ${DOCS_FOLDER}/BBDUK_adapters/
   ln -fs ${READS}/*.fastq.gz ${RAWDATA_FOLDER}
   echo "DONE linking folders!"
}


# run pipeline with test data

test_data(){

   mkdir -p ${ROOT_FOLDER_NAME}/example_data
   export RAWDATA_FOLDER=$(pwd)/${ROOT_FOLDER_NAME}/example_data #change input folder to example
   cd ${RAWDATA_FOLDER}

   #change data..use cp for now on HPC
   echo "Copying test data"

   cp -n /usr/share/sequencing/nextseq/processed/200318/fastq/322_FD2a_S118_R1_001.fastq.gz .
   cp -n /usr/share/sequencing/nextseq/processed/200318/fastq/322_FD2a_S118_R2_001.fastq.gz .
   cp -n /usr/share/sequencing/nextseq/processed/200318/fastq/322_FD2b_S119_R1_001.fastq.gz .
   cp -n /usr/share/sequencing/nextseq/processed/200318/fastq/322_FD2b_S119_R2_001.fastq.gz .
 
 #  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR114/039/SRR11487939/SRR11487939_1.fastq.gz
 #  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR114/039/SRR11487939/SRR11487939_2.fastq.gz

   cd -

   echo "DONE copying test data"
}


# Run bbduk adapter & quality trimming

run_bbduk(){
   echo "Running BBDuk Adapter & Quality Trimming"

   . ./scripts/run_bbduk.sh

   echo "DONE Trimming!"
   cd -

}

# Run seqtk subsampling & merging

run_seqtk(){
   echo "Running Seqtk Subsampling & Read Merging"

   . ./scripts/run_seqtk.sh

   echo "DONE Subsampling & Merging!"
   cd -
}

#  Run metaphlan3 taxonomic classification

run_metaphlan(){
   echo "Running Metaphlan3 Taxonomic Classification"

   . ./scripts/run_metaphlan.sh

   echo "DONE Metaphlan3 Taxonomic Classification!"
}


# run pipeline

metagenomics_analysis_main
