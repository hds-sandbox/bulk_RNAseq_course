---
title: Ucloud setup for data analysis
summary: In this lesson we explain how to start an Rstudio session for data analysis
---

# Setup for teaching in uCloud

!!! note "Section Overview"

    &#128368; **Time Estimation:** 20 minutes  

    &#128172; **Learning Objectives:**    

    1. Start a transcriptomics app job in Ucloud for the next lessons in data analysis
    
## Submit the job in Ucloud

Access [Ucloud](https://cloud.sdu.dk) with your account and choose the project `Sandbox RNASeq Workshop` where you have been invited.

![](./img/05a_data_analysis_setup/chooseProject.png)

Click on `Apps` on the left-side menu, and search for the application `Transcriptomics Sandbox` and click on it.

![](./img/05a_data_analysis_setup/chooseTranscriptomics.png)

You will be met with a series of possible parameters to choose. However, we have prepared the parameters already for you! Just click on `Import parameters`:

![](./img/05a_data_analysis_setup/importParameters.png)

Then, `Import file from UCloud`:

![](./img/05a_data_analysis_setup/importParameters2.png)

And select the `jobParameters.json` in:

- `sandbox_bulkRNASeq` -\> `bulk_RNAseq_course` -\> `Scripts` -\> `ucloud_analysis_setup` -\> `jobParameters.json`

!!! warning 
    **Make sure that the hard-drive icon says `sandbox_bulkRNASeq`!!**

    Otherwise, click on the down arrow (**&or;**) icon and search for the folder.

    ![](./img/05a_data_analysis_setup/importParameters3.png)

Let's take a look at the parameters we have chosen. We have given it a `Job name`, `Hours`, `Machine type` as well as a `Mandatory Parameter` `Select a module`. We have selected the module `Introduction to bulk RNAseq analysis in R`. This module will load the materials necessary to follow the next lessons. It will also contain a backup of the preprocessing results so that you may continue in case that your preprocessing did not work.

![](./img/05a_data_analysis_setup/selectedParams.png)

In order to add your own preprocessing results, go to `Select folders to use` and add the folder that contains the results of the pipeline. If you have not move them yet, they will be in your `Member Files`.

![](./img/05a_data_analysis_setup/selectedParams2.png)

You are ready to run the app by clicking on the button on the right column of the screen (`submit`).

<p align="center">

<img src="./img/05a_data_analysis_setup/submit.png" width="300"/>

</p>

Now, wait some time until the screen looks like the figure below. It usually takes a few minutes for everything to be ready and installed. You can always come back to this screen from the left menu Runs on uCloud, so that you can add extra time or stop the app if you will not use it.

![](./img/05a_data_analysis_setup/startapp.png)

Now, click on `open interface` on the top right-hand side of the screen. You will start Rstudio through your browser!

On the lower right side of Rstudio, where you see the file explorer, there should be a folder `Intro_to_bulkRNAseq`. Here you will find the materials of the course. If you have added your own preprocessing results, they should also be there.

![](./img/05a_data_analysis_setup/courseMaterial.png)

You are ready to start analysing your data!

## Stopping the app

When you are done, go on `Runs` in uCloud, and choose your app if it is still running. Then you will be able to stop it from using resources.

![](./img/05a_data_analysis_setup/stopRun.png)

## Saved work

After running a first work session, everything that you have created, including the scripts and results of your analysis, will be saved in your own personal *"Jobs"* folder. Inside this folder there will be a subfolder called *Transcriptomics Sandbox*, which will contain all the jobs you have run with the Transcriptomics Sandbox app. Inside this folder, you will find your folder named after the job name you gave in the previous step.

1. Your material will be saved in a volume with your username, that you should be able to see under the menu `Files`. 

![](./img/05a_data_analysis_setup/savedWork1.png)

1. Go to `Jobs → Transcriptomics Sandbox → job_name → Intro_to_bulkRNAseq`

![](./img/05a_data_analysis_setup/savedWork2.png)

## Restarting the Rstudio session

If you want to keep working on your previous results, you can restart an Rstudio session following these steps:

Click on `Apps` on the left-side menu, and look for the application `Transcriptomics Sandbox` and click on it.

![](./img/05a_data_analysis_setup/chooseTranscriptomics.png)

You will be met again with a series of possible parameters to choose. You have to assign again the `Import parameters` file as before, or **you can click on one of your previous parameters**.

`sandbox_bulkRNASeq` -> `bulk_RNAseq_course` -> `Scripts` -> `ucloud_analysis_setup` -> `jobParameters.json`

![](./img/05a_data_analysis_setup/importParameters4.png)

In *"Select folders to use"*, add the folder with the results of your previous job:

Go to:

 `Member Files: your_username` -> `Jobs` -> `Transcriptomics Sandbox` -> `job_name` -> `Intro_to_bulkRNAseq`
 
Then, click "Use."

![](./img/05a_data_analysis_setup/restartJob.png)

You are ready to run the app by clicking on the button on the right column of the screen (`submit`). After opening the Rstudio interface, you should be able to access the folder `introduction_bulkRNAseq_analysis`, where you will find your course notebooks and results from your previous work!
