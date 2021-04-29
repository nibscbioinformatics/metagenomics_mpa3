<img src="https://static.wixstatic.com/media/e40e76_52d2db31e5264d31aaea0319cb583acf~mv2.png/v1/fill/w_380,h_358,al_c,q_85,usm_0.66_1.00_0.01/NIBSC%20square.webp" alt="Logo of the project" align="right">

# Shotgun Sequencing Metagenomics Pipeline &middot; 
> Metaphlan3 Taxonomic Classification

This pipeline takes raw Illumina paired-end fastq files as input, performs adapter trimming, subsampling and merging of reads and Metaphlan3 taxonomic classifiction

## Prerequisites

The following is required to run this pipeline:
- x86_64 Linux OS
- Conda ((If not installed see [here](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) ))
- Paired-end Illumina fastq files in the format `*_R1_001.fastq.gz` and `*_R2_001.fastq.gz` (this format be modifed in the run_bbduk.sh script - see the comment ('#') sections of this script)

## Getting Started

1. Clone the github repo and navigate to the directory

```
git clone https://github.com/nibscbioinformatics/metagenomics_mpa3.git
cd metagenomics_mpa3
```

2. Activate conda 

3. Create a conda enviroment to perform the analysis by running the following (**NB environment must be named metaphlan3**)

```
conda env create --name metaphlan3 --file=./docs/environment.yml
```

4. Activate the metaphlan3 conda environment
```
conda activate metaphlan3
```

5. Run the `prepare_metaphlandb.sh` script. This will take some time to run as it downloads and constructs the metaphlan reference database.

```
./prepare_metaphlandb.sh
```

6. Change the `$READS` and `$LINKPATH_DB` file paths in the `main_metagenomics.sh` script.
- `$READS` path should point to the folder containing your reads.
- `$LINKPATH_DB` should point to the folder storing the metaphlan reference database (given as output by `prepare_metaphlandb.sh`)

```bash
#!/usr/bin/env bash


### Workflow for shotgun metagenomics analysis

## Root folder name
NAME=nibsc_metagenomics

echo "Please Check File Paths in main_metagenomics.sh"

READS='/FULL/PATH/TO/data/' # change full path your data directory
LINKPATH_DB='/FULL/PATH/TO/reference' # change path to LINKPATH provided by `prepare_metaphlan.sh` output
```

## Test data

To test if the pipeline is working correctly, please edit the `main_metagenomics.sh` script and uncomment the `test_data` function 

```bash
metagenomics_analysis_main(){
   
   create_folders 
   set_variables # -> Never comment this function
#   test_data # -> remove the '#' before `test_data` to test the pipeline
   run_bbduk 
   run_seqtk
   run_metaphlan
   echo $LINKPATH_DB
}

```
This will download a small test dataset and execute the pipeline to ensure everything is working correctly.

The test data used for this workflow was provided by the authors of 'Developing standards for the microbiome field' (https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-020-00856-3])

## Running the Pipeline

Finally, run the `main_metagenomics.sh` script.   
```
./main_metagenomics.sh
```

## Accessing the Output

Output will be located in the `nibsc_metagenomics/analysis/metaphlan3/merged_table` folder.
This will contain two tables: 
- a table containing all species-level taxonomic classifications with relative abundance estimates per-sample `merged_species_table.txt` 
- a table containing all the taxonomic clades detected and their relative abundances per sample `merged_abundance_table.txt` 

## Overview of metagenomics_mpa3 Directory

```bash
   |-docs
   |-nibsc_metagenomics
   |---analysis
   |-----bbduk_trimmed_reads
   |-----metaphlan
   |-------merged_table
   |-------profiles
   |-----seqtk_output
   |---docs
   |-----BBDUK_adapters
   |---rawdata
   |---reference
   |-----reference_database
   |-reference
   |---reference_database
   |-----metaphlan3
   |---tmp
   |-----bowtie2-2.4.2-linux-x86_64
   |-------doc
   |-------example
   |---------index
   |---------reads
   |---------reference
   |-------scripts
   |-scripts
```

The `scripts` folder contains all the bash scripts used to execute the pipeline
The `docs` folder contains the adapter sequences `adapter.fa` and the `environment.yml` file used to create the conda environment.
The `reference` folder containd the bowtie2 executable and files in `tmp` and the indexed metaphlan3 database in the `metaphlan3` folder. 
The `nibsc_metagenomics` folder houses all the output from the pipeline (`analysis`), the pipeline input (`rawreads`), the test_data (`example_data`) and resources (`tools`). This includes:
- The `analysis` folder which contains all the output. The main output is located within the `metaphlan/merged_table` folder, where the total abundance table`merged_abundance_table.txt`and species level abundance tables `merged_species_table.txt` are located.
- The `rawdata` folder contains the raw read input specifed in `READS` path
- The `docs` folder contains the adapter sequences `adapter.fa` and the `environment.yml` file used to create the conda environment.

## Pipeline Execution & Parameters

The metagenomics pipeline scripts are contained within the `metagenomics_mpa3/scripts/` directory. 

**BBduk** *Parameters*

- -Xmx : memory allocation for task
- -ktrim : trim bases to right of kmer read:adapter match
- -k : k-mer size of reads & adapters
- -mink : value for shortest k-mer size searched
- -hdist : hamming distance (mismatches tolerated)
- -qtrim : quality trimming 
- -minlen : minimum lenght of sequences
- -t : number of threads
- -tpe : trim read pairs to same length
- -tbo : trim adapters based on pair overlap detection using BBMerge

**Seqtk** *Parameters*

- -s : random seed (**Use same random seed for read pairing**)

**Metaphlan** *Parameters*

- --input_type : FASTQ or BAM 
- --index : Run the analysis using this database version
- --no-map : Do not store intermediate bowtie2 map file
- --bowtie2db : Use the pre-built metaphlan3 database at the specficed location
- --bowtie2_exe : Full path and name of bowtie2 executable
- --nproc : use multiple CPU

## Acknowledgements

Current Challenges and Best Practice Protocols for Microbiome Analysis
Richa Bharti, Dominik G Grimm
Briefings in Bioinformatics (BIB), 2019 (in press, https://doi.org/10.1093/bib/bbz155)