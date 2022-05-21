#!/usr/bin

echo "Sys.setenv(RENV_PATHS_CACHE = 'work/sandbox_bulkRNAseq_testAndFeedback/envs/cache')" > ~/.Rprofile
echo "renv::load(project = '/work/sandbox_bulkRNAseq_testAndFeedback/envs')" >> ~/.Rprofile
echo "renv::repair()" >> ~/.Rprofile

printf "Done.\n"