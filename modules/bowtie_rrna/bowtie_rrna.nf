#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'bowtie_rrna'

// Specify DSL2
nextflow.preview.dsl = 2

// TODO check version of cutadapt in host process --> CUTADAPT 2.6 (latest is 2.9)

// Define default nextflow internals
params.internal_outdir = './results'
params.internal_process_name = 'bowtie_rrna'

//Prefix to define the output file 
params.internal_output_prefix = ''

// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

process bowtie_rrna {
    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input:
        tuple val(sample_id), path(reads), path(bowtie_index)

    output:
        tuple val(sample_id), path("${reads.simpleName}.bam"), emit: rrnaBam
        tuple val(sample_id), path("${reads.simpleName}.fq"), emit: unmappedFq

    script:
    """
    gunzip -c $reads | bowtie -v 2 -m 1 --best --strata --threads ${task.cpus} -q --sam --norc --un ${reads.simpleName}.fq ${bowtie_index}/small_rna_bowtie - | \
    samtools view -hu -F 4 - | \
    sambamba sort -t 8 -o ${reads.simpleName}.bam /dev/stdin
    """
}