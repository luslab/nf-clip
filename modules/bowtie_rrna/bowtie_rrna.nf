#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'bowtie_rrna'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = params.outdir
params.internal_process_name = 'bowtie_rrna'

// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

process bowtie_rrna {
    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input:
        tuple val(sample_id), path(reads), path(bowtie_index)

    output:
        tuple val(sample_id), path("${sample_id}.sorted.bam"), emit: rrnaBam
        tuple val(sample_id), path("${sample_id}.unaligned.fq"), emit: unmappedFq
        path "${sample_id}.bowtie.log", emit: report

    shell:
    //bowtie [options]* <ebwt> {-1 <m1> -2 <m2> | --12 <r> | --interleaved <i> | <s>} [<hit>]
    """
    gunzip -c $reads | \
    bowtie -v 2 -m 1 --best --strata --threads ${task.cpus} -q --sam --norc --un ${sample_id}.unaligned.fq ${bowtie_index}/small_rna_bowtie - 2> ${sample_id}.bowtie.log | \
    samtools view -hu -F 4 - | \
    sambamba sort -t ${task.cpus} -o ${sample_id}.sorted.bam /dev/stdin
    """
}

// 