#!/bin/bash

cp /work/778339/raw_reads/samplesheet.csv /work/samplesheet.csv
cp /work/778339/Scripts/ucloud_preprocessing_setup/nf-params_salmon.json /work/nf-params_salmon.json
cd /work

nextflow run nf-core/rnaseq -r 3.11.2 -params-file /work/nf-params_salmon.json -profile conda --max_cpus 8 --max_memory 40GB

# Search for the last file created by the pipeline, the multiqc_report, recursively
file_path=$(find /work/preprocessing_results_salmon -name "multiqc_report.html" 2>/dev/null)

# Check if the file exists
if [[ -n "$file_path" ]]; then
    # Clean run if the pipeline is completed
    rm -r /work/work
    mv /work/nf-params_salmon.json /work/preprocessing_results_salmon/nf-params_salmon.json

fi
