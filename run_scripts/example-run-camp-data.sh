#!/bin/sh

## Script to run luslab/group-nextflow-clip on CAMP
## Copy this script to a working folder

## Help stuff and param setting
usage="$(basename "$0") [-h] [-reads folder] [-bowtie_rRNA_index folder] [-genome_star_index folder] [-genome_fai genome_index_file] [-] \
-- Run Nextflow CLIP pipeline on CAMP with your own data.

where:
    -h  show this help text
    -reads  give the directory where your reads live, make sure they have ending .fq.qz not .fastq.gz
    -bowtie_rRNA_index  give the directory for your pre-mapping bowtie index
    -genome_star_index directory for genome STAR index
    -genome_fai path to genome fasta index file"

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    reads) reads=$OPTARG
       ;;
    :) printf "missing argument for -%reads\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
    bowtie_rRNA_index) bowtie_index=$OPTARG
       ;;
    :) printf "missing argument for -%bowtie_rRNA_index\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
    genome_star_index) star_index=$OPTARG
       ;;
    :) printf "missing argument for -%genome_star_index\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
    genome_fai) genome_fai=$OPTARG
       ;;
    :) printf "missing argument for -%genome_fai\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))


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
