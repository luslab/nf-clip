#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// fastqc reusable component
process getcrosslinkcoverage {
    input:
      each bed
      path fai

    output:
      tuple path("${bed.simpleName}.bedgraph.gz"), path("${bed.simpleName}.norm.bedgraph.gz")
    //   path "${bed.baseName}.norm.bedgraph.gz"

    script:
    """
    # Raw bedgraphs
    zcat $bed | awk '{OFS = "\t"}{if (\$6 == "+") {print \$1, \$2, \$3, \$5} else {print \$1, \$2, \$3, -\$5}}' | pigz > ${bed.simpleName}.bedgraph.gz

    # Normalised bedgraphs
    TOTAL=`zcat $bed | awk 'BEGIN {total=0} {total=total+\$5} END {print total}'`
    echo \$TOTAL
    zcat $bed | awk -v total=\$TOTAL '{printf "%s\\t%i\\t%i\\t%s\\t%f\\t%s\\n", \$1, \$2, \$3, \$4, 1000000*\$5/total, \$6}' | \
    awk '{OFS = "\t"}{if (\$6 == "+") {print \$1, \$2, \$3, \$5} else {print \$1, \$2, \$3, -\$5}}' | \
    sort -k1,1 -k2,2n | pigz > ${bed.simpleName}.norm.bedgraph.gz
    """
}

//  workflow get_crosslinks {
//     take: inputBed
//     main:
//       getcrosslinkcoverage(inputBed)
//     emit:
//       crosslinkcoverage.out
// }

// rule coverageXlinks:
//     input:
//         "results/xlinks/{sample}.xl.bed.gz"
//     output:
//         raw="results/xlinks/bedgraph/{sample}.bedgraph.gz",
//         xpmbg="results/xlinks/bedgraph/{sample}.normalised.bedgraph.gz",
//         xpmbgpos=temp("results/xlinks/bigwig/{sample}.normalised.pos.bedgraph"),
//         xpmbgneg=temp("results/xlinks/bigwig/{sample}.normalised.neg.bedgraph"),
//         xpmbwpos="results/xlinks/bigwig/{sample}.normalised.pos.bigwig",
//         xpmbwneg="results/xlinks/bigwig/{sample}.normalised.neg.bigwig",
//     params:
//         normaliseclip=config['normaliseclip'],
//         fai=config['fai'],
//         cluster="-N 1 -c 1 --mem-per-cpu=16GB -J coverageXlinks -t 12:00:00 -o logs/coverageXlinks.{sample}.%A.log"
//     shell:
//         """
//         # Raw
//         zcat {input} | awk '{{OFS = "\t"}}{{if ($6 == "+") {{print $1, $2, $3, $5}} else {{print $1, $2, $3, -$5}}}}' | pigz > {output.raw}

//         # Normalised to xlinks per million
//         {params.normaliseclip} {input} {output.xpmbg}

//         """

// # Script to create normalised bedgraphs
// # A. M. Chakrabarti
// # 21st December 2018
// IN=$1
// OUT=$2
// # Calculate total
// TOTAL=`zcat $IN | awk 'BEGIN {total=0} {total=total+$5} END {print total}'`
// echo Total crosslinks: $TOTAL
// # Normalising xlink bed
// zcat $IN | awk -v total=$TOTAL '{printf "%s\t%i\t%i\t%s\t%f\t%s\n", $1, $2, $3, $4, 1000000*$5/total, $6}' | pigz > ${OUT}.tmp
// # Converting to bedgraph
// zcat ${OUT}.tmp | awk '{OFS = "\t"}{if ($6 == "+") {print $1, $2, $3, $5} else {print $1, $2, $3, -$5}}' | sort -k1,1 -k2,2n | pigz > $OUT
// rm ${OUT}.tmp(base)

// zcat $bed | awk -v total=\$TOTAL '{printf "%s\t%i\t%i\t%s\t%f\t%s\n", \$1, \$2, \$3, \$4, 1000000*\$5/total, \$6}' | pigz > ${bed.baseName}.norm.bedgraph.gz \