#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'peka'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = './results'
params.internal_process_name = 'peka'

/*-------------------------------------------------> PEKA PARAMETERS <-----------------------------------------------------*/

params.internal_genome = "$baseDir/input/chr20.fa"
params.internal_genome_fai = "$baseDir/input/chr20.fa.fai"
params.internal_regions_file = "$baseDir/input/regions_GENCODE_v30.gtf.gz"
params.internal_window = 40
params.internal_window_distal = 150
params.internal_kmer_length = 4
params.internal_top_n = 20
params.internal_percentile = 0.7
params.internal_min_relativ_occurence = 2
params.internal_clusters = 5
params.internal_smoothing = 6
params.internal_all_outputs = "False"
params.internal_regions = "None"
params.internal_subsample = "True"

/*-------------------------------------------------------------------------------------------------------------------------------*/



// Peka specific params


// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

// fastqc reusable component
process peka {
    publishDir "${params.internal_outdir}/${params.internal_processname}",
        mode: "copy", overwrite: true

    input:
      tuple val(sampleid), path(peaks), path(xls)

    output:
      tuple val(sample_id), path("*.{pdf,tsv}"), emit: results

    script:
    """
    #!/usr/bin/env python
    import importlib.util
    spec = importlib.util.spec_from_file_location("peka", "/home/src/kmers.py")
    pe = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(pe)

    pe.run($peaks,
     $xls,
     "${params.internal_genome}",
     "${params.internal_genome_fai}", 
     "${params.internal_regions_file}",
     "${params.internal_window}",
     "${params.internal_window_distal}",
     "${params.internal_kmer_length}",
     "${params.internal_top_n}",
     "${params.internal_percentile}",
     "${params.internal_min_relativ_occurence}",
     "${params.internal_clusters}",
     "${params.internal_smoothing}",
     "${params.internal_all_outputs}",
     "${params.internal_regions}",
     "${params.internal_subsample}")
    """
}
