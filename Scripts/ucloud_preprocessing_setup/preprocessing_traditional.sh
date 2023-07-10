#!/bin/bash

cp /work/778339/samplesheet.csv /work/samplesheet.csv
cp /work/778339/Scripts/nf-params_traditional.json /work/nf-params_traditional.json
cd /work

nextflow run nf-core/rnaseq -r 3.11.2 -params-file /work/nf-params_traditional.json -profile conda --max_cpus 8 --max_memory 40GB