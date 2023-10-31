# Bulk RNAseq workshop website

This branch hosts and creates the self-learning material for the course.

The theory lessons (02 to 05a md files in `develop`) are stand-alone.
The practical lessons (05b-09) are created by knitting the Rmd files in the subfolder `develop/rmd`. This is because one needs to make sure the code runs properly first before knitting the document. The Rmd notebooks are then knitted into github documents (using the yaml header of each Rmd) that almost have proper md format. These will be saved in the subfolder `develop/rmd/develop`. There are still some weird things that need to be changed. After creating the md files, you need to run the jupyter notebook `develop/rmd/modify_md.ipynb`, which will do some formatting of the files and move them to the correct `develop` main folder.

When you are ready to push changes, do a git add, commit and push. The `.github/workflows/render_page.yml` will automatically render the webpage in the `gh-pages` branch once pushed to remote.
