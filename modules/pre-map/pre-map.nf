#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// fastqc reusable component
process bowtie_rrna {
    input:
        path reads
        path bowtie_index

    output:
         file 'unmapped_reads_*'
         file '*_mapped.sam'

    script:
    """
    echo $reads
    echo $bowtie_index
    """    
 // gunzip -c $reads | bowtie -v 2 -m 1 --best --strata --threads 8 -q --sam --norc --un unmapped_reads_ $bowtie_index - _mapped.sam
//     samtools view -hu -F 4 $sam | sambamba sort -t 8 -o $bam
}


 workflow premap {
    take: 
        rds
        idx
    main:
      bowtie_rrna(rds, idx)
    emit:
      bowtie_rrna.out | view
}
