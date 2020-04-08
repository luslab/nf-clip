#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

def check_internal_overrides(String moduleName, Map parentParams)
    {
        // get params set of keys
        Set paramsKeySet = parentParams.keySet()

        // Interate through and set internals to the correct parameter at runtime
        paramsKeySet.each {
            if(it.startsWith("internal_")) {

                def searchString = moduleName + '_' + it.replace('internal_', '');

                if(paramsKeySet.contains(searchString)) {
                    params.replace(it, params.get(searchString))
                }
            }
        }
    }