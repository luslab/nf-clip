#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
//what is this?
params.outdir = './results'
params.multiqc_processname = 'multiqc'

// multiqc reusable component
process multiqc {
    publishDir "${params.outdir}/${params.multiqc_processname}",
        mode: "copy", overwrite: true
    label 'mid_memory'

    input:
      path log_dir

    output:
      path out_dir

    script:
    """
    multiqc $log_dir -o $out_dir
    """
}