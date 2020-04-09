#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.paraclu_processname = 'paraclu'
params.paraclu_min_value = 10
params.paraclu_max_cluster_length = 200
params.paraclu_min_density_increase = 2

// paraclu reusable component
process paraclu {
    publishDir "${params.outdir}/${params.paraclu_processname}",
        mode: "copy", overwrite: true
    label 'mid_memory'

    input:
      path crosslinks

    output:
      file "*_peaks.bed.gz"

    script:
    """
    !/usr/bin/env python

    import pandas
    from subprocess import call

    file_in = $crosslinks
    sample_name = file_in.split('/')[-1]
    if sample_name.endswith('.gz'):
      file_out = sample_name.replace('.bed', '_peaks.bed')
    else:
      file_out = sample_name.replace('.bed', '_peaks.bed.gz')
    df_in = pd.read_csv(file_in,
                        names = ["chrom", "start", "end", "name", "score", "strand"],
                        header=None, sep='\t')

    df_out = df_in[['chrom', 'strand', 'start', 'score']]

    df_out.sort_values(['chrom', 'strand', 'start'], ascending=[True, True, True], inplace=True)

    paraclu_input = sample_name + '.paraclu_input'
    paraclu_output = sample_name + '.paraclu_output'

    df_out.to_csv(paraclu_input, sep='\t', header=None, index=None)

    call(f'paraclu ${params.paraclu_min_value} "{paraclu_input}" | paraclu-cut.sh -l ${params.paraclu_max_cluster_length} -d ${params.paraclu_min_density_increase} > "{paraclu_output}"', shell=True)
    df_in = pd.read_csv(paraclu_output,
                        names = ["sequence_name", "strand","start", "end", "number_of_positions",
                                "sum_of_data_values", "min_density", "max_density"],
                        header=None, sep='\t')
    df_in['fourth_column'] = '.'
    df_out = df_in[['sequence_name', 'start', 'end', 'fourth_column', 'sum_of_data_values', 'strand']]
    df_out.sort_values(['sequence_name','start', 'end', 'strand'],
                      ascending=[True, True, True, True], inplace=True)
    df_out.to_csv(file_out, sep='\t', header=None, index=None)
    call(f'rm "{paraclu_input}"', shell=True)
    call(f'rm  "{paraclu_output}"', shell=True)

    """
}