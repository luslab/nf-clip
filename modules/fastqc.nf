#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

process fastqc {

// Input is a tuple of sample ids and the path to the FASTQ file
    input:
        tuple sample_id, path(reads) 

// Output is the directory to which FastQC will put its files
// FastQC outputs are *_fastqc.{html,zip}
    output:
        path("fastqc_$sampleid")

    script:
    """
    mkdir fastqc_$sampleid
    fastqc -q -o fastqc_$sampleid $reads
    """

}