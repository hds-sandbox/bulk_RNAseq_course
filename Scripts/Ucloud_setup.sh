#!/usr/bin

echo "Sys.setenv(RENV_PATHS_CACHE = '/work/82207/envs_4.2/cache')" > ~/.Rprofile
echo "renv::load(project = '/work/82207/envs_4.2')" >> ~/.Rprofile
echo "renv::repair()" >> ~/.Rprofile


FILE="introduction_bulkRNAseq_analysis"
if [[ -d "$FILE" ]]; then
	cd $FILE
	ln -s ../82207/bulk_RNAseq_course/Data/ ./Data
	echo "$FILE exists. No overwriting."
else
	echo "No $FILE found. Creating new directory"
	mkdir $FILE
	cd $FILE
	mkdir Results
	cp -r /work/82207/bulk_RNAseq_course/Notebooks ./
	ln -s ../82207/bulk_RNAseq_course/Data/ ./Data
fi

echo "Done."