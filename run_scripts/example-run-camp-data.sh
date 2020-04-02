#!/bin/sh

## Script to run luslab/group-nextflow-clip on CAMP
## Copy this script to a working folder

## Help stuff and param setting
usage="$(basename "$0") [-h] [-r folder] [-b folder] [-s folder] [-f genome_index_file] [-] \
-- Run Nextflow CLIP pipeline on CAMP with your own data.

where REQUIRED parameters are:
    -h  show this help text
    -r  give the directory where your reads live, make sure they have ending .fq.qz not .fastq.gz
    -b  give the directory for your pre-mapping bowtie index
    -s directory for genome STAR index
    -f path to genome fasta index file"

while getopts ':r:b:s:f:h' option; do
  case "$option" in
    :) printf "\-$OPTARG requires an argument\n" >&2
       echo "$usage" >&2
       exit 1
       ;;
    r) reads=$OPTARG
       ;;
    b) bowtie_index=$OPTARG
       ;;
    s) star_index=$OPTARG
       ;;
    f) genome_fai=$OPTARG
       ;;
    h) echo "$usage"
       exit
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
if ((OPTIND == 1))
then
    echo "$usage" >&2
    exit 1
fi
shift $((OPTIND - 1))
if ! $reads || ! $bowtie_index || ! $star_index || ! $genome_fai
then
    echo "You are missing key parameters...\n"
    echo "$usage" >&2
    exit 1
fi

## LOAD REQUIRED MODULES
ml purge
ml Nextflow/20.01.0
ml Singularity/3.4.2
ml Graphviz

## UPDATE PIPLINE
nextflow pull luslab/group-nextflow-clip

## RUN PIPELINE
nextflow run luslab/group-nextflow-clip \
  -r dev \
  -profile crick \
  --reads $reads \
  --bowtie_index $bowtie_index \
  --star_index $star_index \
  --genome_fai $genome_fai
