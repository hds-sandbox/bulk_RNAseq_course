#!/usr/bin

echo "Sys.setenv(RENV_PATHS_CACHE = 'work/sandbox_bulkRNAseq_testAndFeedback/envs/cache')" > ~/.Rprofile
echo "renv::load(project = '/work/sandbox_bulkRNAseq_testAndFeedback/envs')" >> ~/.Rprofile
echo "renv::repair()" >> ~/.Rprofile

mkdir introduction_bulkRNAseq_analysis
cd introduction_bulkRNAseq_analysis
mkdir "Results"

git init
git remote add origin https://github.com/hds-sandbox/bulk_RNAseq_course.git
git config core.sparseCheckout true
echo "Assignments/" >> .git/info/sparse-checkout
echo "Environments/" >> .git/info/sparse-checkout
echo "Notebooks/" >> .git/info/sparse-checkout
git pull --depth=1 origin spring_2022

rm .gitignore

printf "Done.\n"