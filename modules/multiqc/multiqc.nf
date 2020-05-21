#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Specify DSL2
nextflow.preview.dsl = 2

// Define internal params
module_name = 'multiqc'

// Local default params
params.internal_outdir = params.outdir
params.internal_process_name = 'multiqc'

/*-------------------------------------------------> FASTQC PARAMETERS <-----------------------------------------------------*/

/*---------------------------------------------------------------------------------------------------------------------------*/

// Check global overrides
nfUtils.check_internal_overrides(module_name, params)

// Main process
process multiqc {
    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true
    
    input:
      tuple path(reports), path(config_path)

    output:
      path "multiqc_report.html", emit: report
      path "multiqc_data/multiqc.log", emit: log
        
    shell:

    args = '-v -x work'

    if("$config_path" != '') {
        args += " -c $config_path"
    }

    """
    multiqc $args .
    """
}