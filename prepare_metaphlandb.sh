#!/usr/bin/env bash

#Run this script once initally to prepare the metaphlan DB & save the path
#Conflicts between bowtie2 and metaphlan conda dependencies.. download bowtie2, set to path and construct metaphlan DB

#need to consider best approach here...
#supply the indexed db, a bowtie 2 conda env to perform indexing,or download bowtie2 (approach used here)
#maybe conda bowtie2 env would work better? Ideally fix metaphlan env and all can be avoided..


prepare_databases_main(){
   create_folders
   #prepare_conda
   prepare_metaphlan
   #cleanup_tmp  #need Bowtie2 for metaphlan run... 
   #prepare_humanndb #possible future feature
   #prepare_krakendb Chrysi requested feature
   echo "Use this path in the workflow scripts"
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

prepare_conda(){

   echo "Building conda env... 
  #eval "$(conda shell.bash hook)" #conda initialisation - more generalisable as dont specify conda.sh location (try on cluster)
  #conda env create -f environment_test.yml -n metaphlan3 #check if works
   echo "DONE building conda env!

}

prepare_metaphlan(){

   echo "Checking and downloading metaphlan database"
   if [ -d "${REFERENCE_FOLDER}/reference_database/metaphlan3" ]; then
      echo "metaphlan3 database already installed" #could improve check; wont catch installation error


   else

      # install bowtie2 to index methaplan genome (check system distribution below)
      # maybe if statment for CL arg (if macOS download x, elif linux download y, rename the compiled bowtie2 folder so works same downstream? 	

      cd $TMP
   #  wget https://github.com/BenLangmead/bowtie2/releases/download/v2.4.2/bowtie2-2.4.2-linux-x86_64.zip #uncomment for HPC
   #  unzip bowtie2-2.4.2-linux-x86_64.zip
   #  rm bowtie2-2.4.2-linux-x86_64.zip
   #  export PATH=$PATH"${TMP}/bowtie2-2.4.2-linux-x86_64:"

      wget https://github.com/BenLangmead/bowtie2/releases/download/v2.4.2/bowtie2-2.4.2-macos-x86_64.zip #comment for HPC
      unzip bowtie2-2.4.2-macos-x86_64.zip  #comment for HPC
      rm bowtie2-2.4.2-macos-x86_64.zip  #comment for HPC
      export PATH=$PATH"${TMP}/bowtie2-2.4.2-macos-x86_64:" #fix 

      mkdir -p ${REFERENCE_FOLDER}/reference_database/metaphlan3
      cd ${REFERENCE_FOLDER}/reference_database/metaphlan3
      wget https://www.dropbox.com/sh/7qze7m7g9fe2xjg/AADlxibskzbPHPoDl6S-FyKka/mpa_v30_CHOCOPhlAn_201901.tar?dl=0
      tar -xvvf mpa_v30_CHOCOPhlAn_201901.tar?dl=0
      bunzip2 mpa_v30_CHOCOPhlAn_201901.fna.bz2
      ${TMP}/bowtie2-2.4.2-macos-x86_64/bowtie2-build --threads 8 mpa_v30_CHOCOPhlAn_201901.fna mpa_v30_CHOCOPhlAn_201901 #comment for HPC
      #${TMP}/bowtie2-2.4.2-linux-x86_64/bowtie2-build --threads 8 mpa_v30_CHOCOPhlAn_201901.fna mpa_v30_CHOCOPhlAn_201901 #uncomment for linux 
      rm mpa_v30_CHOCOPhlAn_201901.tar?dl=0

   fi
   echo "DONE checking and downloading metaphlan database!"
}

#remove tmp folder with bowtie2 (commented out - need this for the metaphlan run)

cleanup_tmp(){

   if [ -d "${TMP}" ]; then
      rm -rf ${TMP}
   fi

}

prepare_databases_main

