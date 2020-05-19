#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
//what is this?
params.outdir = params.outdir
params.multiqc_processname = 'multiqc'

// multiqc reusable component
process multiqc {
    publishDir "${params.outdir}/${params.multiqc_processname}",
        mode: "copy", overwrite: true
    
    input:
        path (file)

    output:
        file "*.html"
        
    script:
    """
    multiqc -x work .
    """
}