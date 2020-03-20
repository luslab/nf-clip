#!/bin/sh

## Script to run luslab/group-nextflow-clip on CAMP
## Copy the script to a working folder

echo $1
export NXF_WORK=$1

## LOAD REQUIRED MODULES
ml purge
ml Nextflow/19.10.0
ml Singularity/3.4.2
ml Graphviz

## UPDATE PIPLINE
nextflow pull luslab/group-nextflow-clip

## RUN PIPELINE
nextflow run luslab/group-nextflow-clip -r dev