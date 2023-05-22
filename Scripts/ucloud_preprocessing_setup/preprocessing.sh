mkdir preprocessing_results
cp 778339/samplesheet.csv samplesheet.csv

cd /work

nextflow run nf-core/rnaseq -r 3.11.2 -params-file /work/778339/Scripts/nf-params_salmon.json -profile conda --max_cpus 8 --max_memory 40GB