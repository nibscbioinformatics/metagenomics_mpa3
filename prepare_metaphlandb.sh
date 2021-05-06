#!/usr/bin/env bash

set -euo pipefail # error handling

#Run this script once initally to prepare the metaphlan DB & save the path

#Conflicts between bowtie2 and metaphlan conda dependencies.. 
#Solution: Perform bowtie2 indexing and run metaphlan3 as seperate processes 

prepare_databases_main(){
   create_folders
   prepare_metaphlan
   #prepare_humanndb #future feature
   #prepare_krakendb #future feature
   echo "Use this path in main_metagenomics.sh"
   echo "LINKPATH_DB="$REFERENCE_FOLDER
}

create_folders(){

   echo "Creating sub-folders..."

   # Sub-folders in the root folder
   for FOLDER in reference
   do
      mkdir -p $PWD/$FOLDER
   done
   export REFERENCE_FOLDER=$PWD/$FOLDER
   mkdir -p ${REFERENCE_FOLDER}/tmp
   export TMP=${REFERENCE_FOLDER}/tmp
   echo "DONE creating sub-folders!"
}


prepare_metaphlan(){

   echo "Checking and downloading metaphlan database"
   
   if [ -d "${REFERENCE_FOLDER}/reference_database/metaphlan3" ]; then
      echo "metaphlan3 database already installed" 


   else

      # install bowtie2 to index methaplan genome 
     
      cd $TMP
      wget https://github.com/BenLangmead/bowtie2/releases/download/v2.4.2/bowtie2-2.4.2-linux-x86_64.zip
      unzip bowtie2-2.4.2-linux-x86_64.zip
      rm bowtie2-2.4.2-linux-x86_64.zip
      export PATH=$PATH"${TMP}/bowtie2-2.4.2-linux-x86_64:" 

      # download the reference db for metaphlan from dropbox, index using bowtie2
      # adjust treads for indexing to speed up!

      mkdir -p ${REFERENCE_FOLDER}/reference_database/metaphlan3
      cd ${REFERENCE_FOLDER}/reference_database/metaphlan3
      wget https://www.dropbox.com/sh/7qze7m7g9fe2xjg/AADlxibskzbPHPoDl6S-FyKka/mpa_v30_CHOCOPhlAn_201901.tar?dl=0
      tar -xvvf mpa_v30_CHOCOPhlAn_201901.tar?dl=0
      bunzip2 mpa_v30_CHOCOPhlAn_201901.fna.bz2
      rm mpa_v30_CHOCOPhlAn_201901.tar?dl=0
      
      ${TMP}/bowtie2-2.4.2-linux-x86_64/bowtie2-build --threads 8 mpa_v30_CHOCOPhlAn_201901.fna mpa_v30_CHOCOPhlAn_201901 
      

   fi
   echo "DONE downloading and indexing metaphlan database!"
}


prepare_databases_main

