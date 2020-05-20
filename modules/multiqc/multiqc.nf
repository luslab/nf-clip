#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.internal_outdir = params.outdir
params.internal_process_name = 'multiqc'
params.internal_config_path = ''

/*-------------------------------------------------> FASTQC PARAMETERS <-----------------------------------------------------*/

/*---------------------------------------------------------------------------------------------------------------------------*/

// multiqc reusable component
process multiqc {
    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true
    
    input:
      path (file)

    output:
      path "multiqc_report.html", emit: report
      path "multiqc_data/multiqc.log", emit: log
        
    shell:

    args = '-v -x work'

    if(params.internal_config_path != '') {
        args += " -c ${params.internal_config_path}"
    }

    """
    multiqc $args .
    """
}