#!/bin/sh

set -e

nextflow run modules/rename-file/test.nf -profile docker,moduletest
nextflow run modules/cutadapt/test.nf -profile docker,moduletest
nextflow run modules/get-crosslinks/test.nf -profile docker,moduletest
nextflow run modules/get-crosslink-coverage/test.nf -profile docker,moduletest
nextflow run modules/paraclu/test.nf -profile docker,moduletest
nextflow run modules/samtools/test.nf -profile docker,moduletest
nextflow run modules/umi-tools/test.nf -profile docker,moduletest
nextflow run modules/fastqc/test.nf -profile docker,moduletest
nextflow run modules/bowtie_rrna/test.nf -profile docker,moduletest
nextflow run modules/star/test.nf -profile docker,moduletest
nextflow run modules/icount/test.nf -profile docker,moduletest
nextflow run modules/peka/test.nf -profile docker,moduletest
