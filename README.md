# Bulk RNAseq workshop website

This branch hosts and generates the self-learning material for the course.

- The theory lessons (02 to 05a *.qmd files in `develop`) are stand-alone.
- The practical lessons (05b-09) are pulled as `*Rmd` files from the Notebooks folder in the `main` branch. These Rmd files are knitted into HTML format for the website. Since the code needs to run before generating the final output, this process takes some time.

To keep the website up to date, stage your changes with `git add`, commit them, and push them to the remote repository. Once pushed, the `.github/workflows/render_page.yml` workflow will automatically generate the updated webpage and deploy it to the `gh-pages` branch. There’s also another workflow running in the main branch that tracks changes to the notebooks (`trigger_webpage.yml`). If any of them get updated, it automatically triggers the Quarto publishing process, making sure those changes are processed and reflected on the website without any extra steps from you. If any of them get updated, it automatically triggers the Quarto publishing process, making sure those changes are processed and reflected on the website without any extra steps from you.

Check the GitHub workflows to see how this is done. 
