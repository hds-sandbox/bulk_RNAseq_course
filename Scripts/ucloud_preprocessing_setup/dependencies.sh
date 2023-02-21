# Go to data/merge folder
mkdir preprocessing

# Initiate conda
conda init bash

# Reset channel priority
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
source ~/.bashrc

cd /work/sequencing_data/merge
