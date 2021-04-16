## Shotgun Metagenomics Workflow


Work in progress...

### Test data
The test data used for this workflow was provided by the authors of 'Developing standards for the microbiome field' (https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-020-00856-3])
The data from the study (NCBI Bioproject ID PRJNA622674) can be accessed [here](https://www.ncbi.nlm.nih.gov/sra/10506348,10506347,10506346,10506345,10506339,10506328,10506322,10506321,10506320,10506319,10506318,10506317,10506316,10506315,10506314,10506313,10506312,10506311,10506310,10506309)


### Steps to run the pipeline

1. Clone the github repo and navigate to the directory

```
git clone git@github.com:nibscbioinformatics/metagenomics_mpa3.git
cd metagenomics_mpa3
```


2. Create a conda enviroment to perform the analysis by running the following (NB environment must be named metaphlan3)

```
conda env create --name metaphlan3 --file=environment.yml
```


3. Run the `prepare_metaphlandb.sh` script. This will take some time to run as it downloads and constructs the metaphlan reference database.

```
./prepare_metaphlandb.sh
```

4. Change the `$READS` and `$LINKPATH_DB` file paths in the `run_metagenomics.sh` script.
- `$READS` path should point to the folder containing your reads.
- `$LINKPATH_DB` should point to the folder storing the metaphlan reference database (given as output by `prepare_metaphlandb.sh`)

```
#!/usr/bin/env bash


### Workflow for shotgun metagenomics analysis

## Root folder name
NAME=YOURFOLDERNAME

echo "Please Check File Paths in run_metagenomics.sh"

READS=/FULL/PATH/TO/data/
LINKPATH_DB=/FULL/PATH/TO/reference 
```

5. Finally, run the `main_metagenomics.sh` script.  
```
./main_metagenomics.sh
```