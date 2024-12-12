#!/bin/bash

cp /work/778339/raw_reads/samplesheet.csv /work/samplesheet.csv
cp /work/778339/Scripts/ucloud_preprocessing_setup/nf-params.json /work/nf-params.json
cd /work

nextflow run nf-core/rnaseq -r 3.11.2 -params-file /work/nf-params.json -profile conda --max_cpus 8 --max_memory 40GB

# Search for the file recursively
file_path=$(find preprocessing_results_star_salmon -name "multiqc_report.html" 2>/dev/null)

# Check if the file exists
if [[ -n "$file_path" ]]; then
    # Clean run
    rm -r /work/work
    mv /work/nf-params.json /work/preprocessing_results_star_salmon/nf-params.json

fi