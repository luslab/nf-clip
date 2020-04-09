#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.peka_processname = 'peka'

// Peka specific params
params.peka_genome = "test/data/GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa"
params.peka_genome_fai = 
params.peka_regions_file =
params.peka_window = 40
params.peka_window_distal = 150
params.peka_kmer_length = 4
params.peka_top_n = 20
params.peka_percentile = 0.7
params.peka_min_relativ_occurence = 2
params.peka_clusters = 5
params.peka_smoothing = 6
params.peka_all_outputs = False
params.peka_regions = None
params.peka_subsample = True


// fastqc reusable component
process peka {
    publishDir "${params.outdir}/${params.kmers_processname}",
        mode: "copy", overwrite: true
    label 'mid_memory'

    input:
      path peak_file
      path sites_file

    output:
      file "*_fastqc.{zip,html}"

    script:
    """
    !/usr/bin/env python
    import ../bin/peka.py
    run()

    

    
    """
}