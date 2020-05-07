#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'star'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = './results'
params.internal_process_name = 'star'

//Prefix to define the output file 
//params.internal_output_prefix = ''

/*-------------------------------------------------> STAR PARAMETERS <-----------------------------------------------------*/

//Add custom arguments
//Copy-paste the desired option in the empty brackets, it will automatically be added to the process.

params.internal_custom_args = ''

// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

// Trimming reusable component
process star {
    // Tag
    //tag "${sample_id}"

    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input:
      each path(reads)
      path star_index

    output:
      path "*Aligned.*.out.*", emit: bamFiles
      path "*Log.final.out", emit: logFiles

    shell:
    
    // Set the main arguments
    star_args = ''
    star_args += "--genomeDir $star_index "
    star_args += "--readFilesIn $reads "

    // Combining the custom arguments and creating star args
    star_args += "$params.internal_custom_args "
    
    // Displays the STAR command line (star_args) to check for mistakes
    println star_args

    output_prefix = reads.baseName

    """
    STAR $star_args --outFileNamePrefix $output_prefix
    """
}
