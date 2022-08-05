#!/usr/bin

echo "Sys.setenv(RENV_PATHS_CACHE = 'work/sandbox_bulkRNAseq_testAndFeedback/envs_4.2/cache')" > ~/.Rprofile
echo "renv::load(project = '/work/sandbox_bulkRNAseq_testAndFeedback/envs_4.2')" >> ~/.Rprofile
echo "renv::repair()" >> ~/.Rprofile


FILE="introduction_bulkRNAseq_analysis"
if [[ -f "$FILE" ]]; then
    echo "$FILE exists. No overwriting."
else
	mkdir introduction_bulkRNAseq_analysis
	cd introduction_bulkRNAseq_analysis
	mkdir Results
	cp -r work/sandbox_bulkRNAseq_testAndFeedback/Notebooks ./
	ls 
fi

# mkdir introduction_bulkRNAseq_analysis
# cd introduction_bulkRNAseq_analysis
# mkdir "Results"

# git init
# git remote add origin https://github.com/hds-sandbox/bulk_RNAseq_course.git
# git config core.sparseCheckout true
# echo "Assignments/" >> .git/info/sparse-checkout
# echo "Environments/" >> .git/info/sparse-checkout
# echo "Notebooks/" >> .git/info/sparse-checkout
# git pull --depth=1 origin spring_2022

# rm .gitignore

echo "Done.\n"