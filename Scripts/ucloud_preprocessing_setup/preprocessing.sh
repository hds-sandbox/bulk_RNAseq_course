cp /work/778339/samplesheet.csv /work/samplesheet.csv
cd /work
nextflow run nf-core/rnaseq -r 3.11.2 -params-file /work/778339/Scripts/nf-params.json -profile conda --max_cpus 8 --max_memory 40GB