#!/bin/bash

cp /work/778339/samplesheet.csv /work/samplesheet.csv
cp /work/778339/Scripts/nf-params.json /work/nf-params.json
cd /work

nextflow run nf-core/rnaseq -r 3.11.2 -params-file /work/nf-params.json -profile conda --max_cpus 8 --max_memory 40GB

# Search for the file recursively
file_path=$(find / -name "multiqc_report.html" 2>/dev/null)

# Check if the file exists
if [[ -n "$file_path" ]]; then
    # Clean run
    nextflow clean
    mv /work/nf-params.json /work/preprocessing_star_salmon/nf-params.json

fi