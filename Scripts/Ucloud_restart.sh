#!/usr/bin

echo "Sys.setenv(RENV_PATHS_CACHE = 'work/sandbox_bulkRNAseq_testAndFeedback/envs_4.2/cache')" > ~/.Rprofile
echo "renv::load(project = '/work/sandbox_bulkRNAseq_testAndFeedback/envs_4.2')" >> ~/.Rprofile
echo "renv::repair()" >> ~/.Rprofile

printf "Done.\n"