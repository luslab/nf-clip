#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.peka_processname = 'peka'

// Peka specific params
params.peka_genome = "$baseDir/input/chr20.fa"
params.peka_genome_fai = "$baseDir/input/chr20.fa.fai"
params.peka_regions_file = "$baseDir/input/regions_GENCODE_v30.gtf.gz"
params.peka_window = 40
params.peka_window_distal = 150
params.peka_kmer_length = 4
params.peka_top_n = 20
params.peka_percentile = 0.7
params.peka_min_relativ_occurence = 2
params.peka_clusters = 5
params.peka_smoothing = 6
params.peka_all_outputs = "False"
params.peka_regions = "None"
params.peka_subsample = "True"


// fastqc reusable component
process peka {
    publishDir "${params.outdir}/${params.peka_processname}",
        mode: "copy", overwrite: true
    label 'mid_memory'

    input:
      tuple val(sampleid), file(peaks), file(xls)

    output:
      // file "${params.outdir}/${params.peka_processname}/results"
      path("results/*.{pdf, tsv}")

    script:
    """
    #!/usr/bin/env python
    import importlib.util
    spec = importlib.util.spec_from_file_location("peka", "$baseDir/bin/peka.py")
    pe = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(pe)

    pe.run("${peaks}",
     "${xls}",
     "${params.peka_genome}",
     "${params.peka_genome_fai}", 
     "${params.peka_regions_file}",
     $params.peka_window, 
     $params.peka_window_distal, 
     $params.peka_kmer_length, 
     $params.peka_top_n, 
     $params.peka_percentile, 
     $params.peka_min_relativ_occurence,
     $params.peka_clusters, 
     $params.peka_smoothing, 
     $params.peka_all_outputs, 
     $params.peka_regions, 
     $params.peka_subsample)
    
    """
}
