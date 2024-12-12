#!/bin/bash
VRNASEQ="3.17.0"
PARAMSF="/work/sequencing_data/scripts_v3.17.0/nf-params_salmon.json"
CONFIGF="/work/sequencing_data/scripts_v3.17.0/maxcores.config"

nextflow run nf-core/rnaseq -r $VRNASEQ -params-file $PARAMSF -profile conda -c $CONFIGF
