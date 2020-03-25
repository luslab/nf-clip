#!/usr/bin/env nextflow
/*
========================================================================================
                         luslab/group-nextflow-clip
========================================================================================
Luscombe lab CLIP analysis pipeline.
 #### Homepage / Documentation
 https://github.com/luslab/group-nextflow-clip
----------------------------------------------------------------------------------------
*/

// Define DSL2
nextflow.preview.dsl=2

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include luslabHeader from './modules/overhead/overhead'

/*------------------------------------------------------------------------------------*/

log.info luslabHeader()

// this is a comment
<<<<<<< HEAD
// This a feature module commit comment
// This a feature module commit comment2
=======
// this is a comment2
>>>>>>> dev
