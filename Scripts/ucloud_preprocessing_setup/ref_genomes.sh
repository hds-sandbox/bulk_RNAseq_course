#!/bin/bash

# Download human (GRCh38) and mouse (GRCm39) genome and annotations
# Release 109
# 2023-07-10

cd /work/778339
mkdir -p ref_genomes/human/GRCh38
cd  /work/778339/ref_genomes/human/GRCh38

wget -L ftp://ftp.ensembl.org/pub/release-109/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz
wget -L ftp://ftp.ensembl.org/pub/release-109/gtf/homo_sapiens/Homo_sapiens.GRCh38.109.gtf.gz

mkdir -p ref_genomes/mouse/GRCm39
cd  /work/778339/ref_genomes/mouse/GRCm39

wget -L ftp://ftp.ensembl.org/pub/release-109/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna_sm.primary_assembly.fa.gz
wget -L https://ftp.ensembl.org/pub/release-109/gtf/mus_musculus/Mus_musculus.GRCm39.109.gtf.gz
