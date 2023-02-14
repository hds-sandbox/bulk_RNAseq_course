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

## Submit a job in Ucloud

Access [Ucloud](https://cloud.sdu.dk) with your account and choose the project `Sandbox RNASeq Workshop` where you have been invited. Or ask to be invited to jose.romero@sund.ku.dk.

![](./img/04c_preprocessing_setup/chooseProject.png)

Click on `Apps` on the left-side menu, and search for the application `nf-core rnaseq` and click on it.

![](./img/04c_preprocessing_setup/chooseRNAseq.png)

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

<p align="center">

<img src="./img/04c_preprocessing_setup/submit.png" width="300"/>

</p>

Now, wait some time until the screen looks like the figure below. It usually takes a few minutes for everything to be ready and installed. You can always come back to this screen from the left menu `Runs` on UCloud, so that you can add extra time or stop the app if you will not use it.

![](./img/04c_preprocessing_setup/startApp.png)

Now, click on `Open terminal` on the top right-hand side of the screen. You will start terminal session through your browser! Once inside the terminal, you will need to do one last thing before starting the pipeline:

```bash
cd sequencing_data/merge
```
![](./img/04c_preprocessing_setup/startRun.png)

Finally we can start the pipeline!

```bash
nextflow run ~/nf-core-rnaseq-3.6/workflow/ -work-dir /work/preprocessing/work -params-file /work/sequencing_data/Scripts/nf-params_salmon.json --max_cpus $CORES -profile conda​
```

You should see a prompt like this, which means that the pipeline started successfully!

![](./img/04c_preprocessing_setup/nf-core_start.png)

## Understanding the pipeline options

Let's divide the command into different sections. First we have:

```
nextflow run ~/nf-core-rnaseq-3.6/workflow/ 
```

While usually one would run an nf-core pipeline using `nextflow run nf-core/rnaseq` and fecth the pipeline remotely, UCloud has installed the pipelines locally. Specifically, it has the version 3.6 installed. The proper way of running a local pipeline is by giving the path to the `workflow` folder of that pipeline to nextflow.

***

Second, we have:

```
-work-dir /work/preprocessing/work
```

This is a nextflow core command that indicates nextflow to create all the intermediary files outside the common drive, avoiding creating a mess in the common folder.

***

Third, we have:

```
-params-file /work/sequencing_data/Scripts/nf-params_salmon.json
```

The `-params-file` argument is another nextflow core argument that allows us to give the nf-core rnaseq pipeline arguments in a [json file](https://www.json.org/json-en.html), instead of creating an excessively long command. Writing the parameters this way allows for better reproducibility, since you can reuse the file in the future. Inside this file, we find the following arguments:

```json
{
    "input": "/work/sequencing_data/merge/samplesheet.csv",
    "outdir": "/work/preprocessing/results_salmon",
    "genome": "GRCh37",
    "pseudo_aligner": "salmon",
    "skip_stringtie": true,
    "skip_rseqc": true,
    "skip_preseq": true,
    "skip_qualimap": true,
    "skip_biotype_qc": true,
    "skip_bigwig": true,
    "skip_deseq2_qc": true,
    "skip_bbsplit": true,
    "skip_alignment": true
}
```

**`--input` parameter**

The `--input` parameter points to the `samplesheet.csv` file that contains all the info regarding our samples. The file looks like this:

|sample    |fastq_1            |fastq_2|strandedness|condition           |
|----------|-------------------|-------|------------|--------------------|
|Control_3 |Irrel_kd_3.fastq.gz|NA     |unstranded  |control             |
|Control_2 |Irrel_kd_2.fastq.gz|NA     |unstranded  |control             |
|Control_1 |Irrel_kd_1.fastq.gz|NA     |unstranded  |control             |
|Mov10_oe_3|Mov10_oe_3.fastq.gz|NA     |unstranded  |MOV10_overexpression|
|Mov10_oe_2|Mov10_oe_2.fastq.gz|NA     |unstranded  |MOV10_overexpression|
|Mov10_oe_1|Mov10_oe_1.fastq.gz|NA     |unstranded  |MOV10_overexpression|
|Mov10_kd_3|Mov10_kd_3.fastq.gz|NA     |unstranded  |MOV10_knockdown     |
|Mov10_kd_2|Mov10_kd_2.fastq.gz|NA     |unstranded  |MOV10_knockdown     |

As you can see, we have also provided an extra column called `condition` specifying the sample type. This will be very useful for our Differential Expression Analysis. In addition, you can also notice that we have a single-end RNAseq experiment in our hands.

**`--outdir` parameter**

The `--outdir` parameter indicates where the results of the pipeline will be saved.

**`--genome` parameter**

The `--genome` parameter indicates that we will be using the version "GRCh37" of the human genome (since we have human samples). We are using the previous version of the genome because there is a [slight issue](https://nf-co.re/usage/reference_genomes) with the version "GRCh38" used in the [AWS iGenomes](https://nf-co.re/usage/reference_genomes) repository.

**`--pseudo_aligner` argument**

The `--pseudo_aligner` argument indicates that we want to use salmon to quantify transcription levels.

Finally, we are skipping several QC and extra steps that we did not explain in the [previous lesson](./04a_preprocessing.md), including `**--skip_alignment**`. We skip traditional alignment in order to save time and computational resources. Do not worry, we have prepared a backup folder that contains the results from a traditional aligment + pseudoquantification for you to freely explore! (More about that [below](#saved-results))

***

We can continue with the next argument:

```
--max_cpus $CORES 
```

This one is a nf-core specific argument that indicates nextflow to only use as maximum the number of CPUs we have requested when we submitted the job. The `$CORES` variable is an environmental variable that was created when you submitted the job (e.g. if you submitted a job with 4 CPUs, `$CORES` will be equal to 4). This argument is not included in the json files because it will not recognise the variable as it is in the command (i.e. it will literally read "$CORES" instead of a number).

***

Lastly, and very importantly:

```
-profile conda
```

Unfortunately, the UCloud implementation of the nf-core pipelines do not currently allow the use of docker or singularity, which are the recommended profile options. We are stuck to use conda to fetch all the necessary software to run the pipeline!

## Restarting a failed run

The nf-core pipelines are not implemented well enough in UCloud. Ideally we would be using docker or singularity to fetch all the required software to run the pipeline, but we are stuck to using Conda, which is prone to errors. Sometimes you will get an error like:

!!! failure

    ```
    Error executing process >
    Caused by:
        Failed to create create conda environment
    ```

![](./img/04c_preprocessing_setup/conda_error.png)

This error is often fixed by just resuming the run using the `-resume` argument:

```
nextflow run ~/nf-core-rnaseq-3.6/workflow/ -work-dir /work/preprocessing/work -params-file /work/sequencing_data/Scripts/nf-params_salmon.json --max_cpus $CORES -profile conda​ -resume
```

## Stopping the app

Once the pipeline is done, go on `Runs` in uCloud and stop it from using more resources than necessary! This will help to keep the courses running for other people.

![](./img/04c_preprocessing_setup/stopRun.png)

## Saved results

After finishing the job, everything that the pipeline has created will be saved in your own personal *"Jobs"* folder. Inside this folder there will be a subfolder called *nf-core: rnaseq*, which will contain all the jobs you have run with the nf-core app. Inside this folder, you will find the results folder named after the job name you gave when you submitted the job.

1. Your material will be saved in a volume with your username, that you should be able to see under the menu `Files`. 

![](./img/04c_preprocessing_setup/savedWork1.png)

1. Go to `Jobs → nf-core: rnaseq → job_name → results_salmon` 

![](./img/04c_preprocessing_setup/savedWork2.png)
 
Now you have access to the full results of your pipeline! As explained in the [previous lesson](04b_pipelines.md), the nf-core rnaseq workflow will create a MultiQC report summarizing most of the steps into a single and beautiful html file that is interactive and explorable. In addition, there will be a folder with the results of the individual QC steps as well as the alignment and quantification results. Take your time and check it all out!