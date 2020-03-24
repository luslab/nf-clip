#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include fastqc from './pre-fastqc.nf'

/*------------------------------------------------------------------------------------*/



exit 0