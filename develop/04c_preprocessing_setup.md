---
title: Ucloud setup to run a preprocessing pipeline
summary: In this lesson we explain how to run the nf-core pipeline in the UCloud computing system
date: 2023-01-17
---

# Running the bulk RNAseq pipeline in uCloud

!!! note "Section Overview"

    &#128368; **Time Estimation:** X minutes  

    &#128172; **Learning Objectives:**    

    1. Learn about the UCloud computing system.
    2. Learn how to submit a job and explore your results folders.
    3. Submit a nf-core RNAseq run on our data

## Submit the job in Ucloud

Access [Ucloud](https://cloud.sdu.dk) with your account and choose the project `Sandbox RNASeq Workshop` where you have been invited. Or ask to be invited to jose.romero@sund.ku.dk.

![](./img/04c_preprocessing_setup/chooseProject.png)

Click on `Apps` on the left-side menu, and search for the application `nf-core rnaseq` and click on it.

![](./img/04c_preprocessing_setup/chooseTranscriptomics.png)

You will be met with a series of possible parameters to choose. However, we have prepared the parameters already for you! Just click on `Import parameters`:

![](./img/04c_preprocessing_setup/importParameters.png)

Then, `Import file from UCloud`:

![](./img/04c_preprocessing_setup/importParameters2.png)

And select the `jobParameters.json` in:

- `sandbox_bulkRNASeq` -\> `bulk_RNAseq_course` -\> `Scripts` -\> `ucloud_preprocessing_setup` -\> `jobParameters.json`

!!! warning 
    **Make sure that the hard-drive icon says `sandbox_bulkRNASeq`!!**
    ![](./img/04c_preprocessing_setup/importParameters3.png)

You are ready to run the app by clicking on the button on the right column of the screen (`submit`).

![](./img/04c_preprocessing_setup/submit.png)

Now, wait some time until the screen looks like the figure below. It usually takes a few minutes for everything to be ready and installed. You can always come back to this screen from the left menu Runs on uCloud, so that you can add extra time or stop the app if you will not use it.

![](./img/04c_preprocessing_setup/startApp.png)

Now, click on `open interface` on the top right-hand side of the screen. You will start terminal session through your browser!

`./bulk_RNAseq_course/Scripts/ucloud_preprocessing_setup/ucloud_setup.sh`

![](./img/04c_preprocessing_setup/copyMaterial.png)



## Understanding the pipeline options



## Restarting a failed run

The nf-core pipelines are not implemented well enough in UCloud. Ideally we would be using docker or singularity to fetch all the required software to run the pipeline, but we are stuck to using Conda, which is prone to errors. Sometimes you will get an error like:

```
Error: unable to create conda environment
```

This error is often fixed by just resuming the run using the `-resume` argument:

```
nextflow run ~/nf-core-rnaseq-3.6/workflow/ -work-dir /work/preprocessing/work -params-file /work/sequencing_data/Scripts/nf-params_salmon.json --max_cpus $CORES -profile conda​ -resume
```

## Stopping the app

Once the pipeline is done, go on `Runs` in uCloud and stop it from using more resources than necessary! This will help to keep the courses running for other people.

![](./img/04c_preprocessing_setup/stopRun.png)

## Saved results

After finishing the job, everything that the pipeline has created will be saved in your own personal *"Jobs"* folder. Inside this folder there will be a subfolder called *nf-core rnaseq*, which will contain all the jobs you have run with the nf-core app. Inside this folder, you will find the results folder named after the job name you gave when you submitted the job.

1. Your material will be saved in a volume with your username, that you should be able to see under the menu `Files`. 

![](./img/04c_preprocessing_setup/savedWork1.png)

1. Go to `Jobs → nf-core rnaseq → job_name → results` 

![](./img/04c_preprocessing_setup/savedWork2.png)
 
Now you have access to the full results of your pipeline! As explained in the [previous lesson](04b_pipelines.md), the nf-core rnaseq workflow will create a MultiQC report summarizing most of the steps into a single and beautiful html file that is interactive and explorable. In addition, there will be a folder with the results of the individual QC steps as well as the alignment and quantification results. Take your time and check it all out!