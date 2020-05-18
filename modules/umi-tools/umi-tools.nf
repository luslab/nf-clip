#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'umi_tools'

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.internal_outdir = './results'
params.internal_process_name = 'umi_tools'

nfUtils.check_internal_overrides(module_name, params)

// dedup reusable component
process umi_tools {
    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input:
      tuple val(sample_id), path(bai), path(bam)
       
    output:
      tuple val(sample_id), path(bam), emit: dedupBam

    script:
    """
    fileName=`basename $bam`
    sampleName="\${fileName%.Aligned.sortedByCoord.out.bam}"
    umi_tools dedup --umi-separator=":" -I $bam -S \${sampleName}.dedup.bam --output-stats=\${sampleName}
    """
}