#!/usr/bin

mkdir introduction_bulkRNAseq_analysis
cd introduction_bulkRNAseq_analysis
git init
git remote add origin https://github.com/hds-sandbox/bulk_RNAseq_course.git
git config core.sparseCheckout true
echo "Assignments/" >> .git/info/sparse-checkout
echo "Environments/" >> .git/info/sparse-checkout
echo "Notebooks/" >> .git/info/sparse-checkout
echo "Scripts/" >> .git/info/sparse-checkout
git pull --depth=1 origin spring2022