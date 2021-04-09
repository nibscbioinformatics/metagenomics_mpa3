## Shotgun Metagenomics Workflow

### Test data
The test data used for this workflow was provided by the authors of 'Developing standards for the microbiome field' (publication available [here](https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-020-00856-3]))
The data from the study (NCBI Bioproject ID PRJNA622674) can be accessed [here](https://www.ncbi.nlm.nih.gov/sra/10506348,10506347,10506346,10506345,10506339,10506328,10506322,10506321,10506320,10506319,10506318,10506317,10506316,10506315,10506314,10506313,10506312,10506311,10506310,10506309)


### Steps to run the pipeline

1. Clone the github repo at  and navigate to the directory

`
git clone https://github.com/MGordon09/metagenomics_mpa3.git 
`
`
cd metagenomics_mpa3
`


2. Create a conda enviroment to perform the analysis by running the following (NB environment must be named metaphlan3)

`
 conda env create --name metaphlan3 --file=environment_test.yml
`

3. For linux users, edit the bowtie2 installation section of  `prepare_metaphlandb.sh` script in the `prepare_metaphlan()` process  (section commented in code).
Linux users will also need to modify `run_metaphlan3.sh` script in the `run_metaphlan()` process (also highlighted in code)
(Other bowtie2 releases available [here](https://github.com/BenLangmead/bowtie2/releases)


4. Run the `prepare_metaphlandb.sh` script. This will take some time to run as it downloads and constructs the metaphlan reference database.

`
./prepare_metaphlandb.sh
`

4. Change the `$READS` and `$LINKPATH_DB` file paths in the `run_metagenomics.sh` script.
The `$READS` path should point to the folder containing your reads.
The `$LINKPATH_DB` will point to the folder storing the metaphlan reference database (given as output by `prepare_metaphlandb.sh`)
`
READS=/FULL/PATH/TO/data/
LINKPATH_DB=/FULL/PATH/TO/reference 
`

5. Finally, run the `run_metagenomics.sh` script.  (Dont forget to `prepare_metaphlandb.sh` if running on linux! )
`
./run_metagenomics.sh
`