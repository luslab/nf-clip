# CLIP nextflow analysis pipeline

![master-pr](https://github.com/luslab/group-nextflow-clip/workflows/master-pr/badge.svg)

![logo](https://github.com/luslab/group-nextflow-clip/blob/dev/images/clip_1.jpg)

## Info

The original CLIP method was first [published](CLIP%20Identifies%20Nova-Regulated%20RNA%20Networks%20in%20the%20Brain) in 2003. 

Two useful papers about the experimental and computational methods are:

- [Advances in CLIP Technologies for Studies of Protein-RNA Interactions](https://doi.org/10.1016/j.molcel.2018.01.005)
- [Data Science Issues in Studying Protein–RNA Interactions with CLIP Technologies](https://doi.org/10.1146/annurev-biodatasci-080917-013525)

There are a number of public data resources available:

 1. iCLIP in a range of cells and tissues by the Ule lab on [iMaps](https://imaps.genialis.com/)
 2. eCLIP in K562 and HepG2 cell lines by [ENCODE](https://www.encodeproject.org/matrix/?type=Experiment&status=released&assay_slims=RNA%20binding&award.project=ENCODE&assay_title=eCLIP&biosample_ontology.classification=cell%20line).

## Development

To collaborate on this pipeline please follow the contribution guidelines written below. These documents will evolve over time so please keep checking regularly.

There is a set process to follow for submitting code so that the codebase is always clear, robust and well tested.

### Software

You will need the following software and tools installed on your dev machine to contribute to this project:

- [Docker](https://hub.docker.com/editions/community/docker-ce-desktop-mac) (Create a docker hub account and create an issue assigned to me to add you to the luslab group)
- Download a GUI for git, I use [Git Kraken](https://www.gitkraken.com/)
- A code editor such as [Visual studio code](https://code.visualstudio.com/)

### Setup

- Install the nextflow code extensions to VS code
- Clone this repo to a dev folder on your machine
- Make sure you are logged into docker hub on your desktop and that you can see the luslab docker hub repo
- From your local repo, run `nextflow run main.nf -profile docker,test --resume` (you can change the maximum memory from the default 8GB to what you have by adding the flag `--max_memory=16.GB` )

### Changing code and contributing

This project uses the "branch-pull" method of development rather than the "fork-pull". Forking a repository is good when you have a public collaboration but it introduces a lot of overhead; instead, we will create topical branches for features or releases that we can then merge into the `dev` branch.

Read [this](https://nvie.com/posts/a-successful-git-branching-model/) article on branching to get an idea about how code is managed on a small/medium project. More information on pull requests can be found [here](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-collaborative-development-models) and [here](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-request-reviews).

![branching](https://github.com/luslab/group-nextflow-clip/blob/dev/images/git-model@2x.png)

The `master` branch is locked and can only be added to using pull requests (PRs). Each pull request **must** be reviewed by at least one other code reviewer. PR's to the master branch will also be subject to automatic testing and code checks. Once the project hits the `beta` milestone, then the `master` branch should always be in a releasable state.

The `dev` branch is a kind of staging area where changes can be assembled into releases. This branch is not explicitly locked as we may at times wish to commit to this directly, especially at the beginning; however, please try to create a different branch for most things.

To start working on a feature first create a set of one or more issues which describe what you want to do. These are automatically populated on the project board and provide a common place to work on various things. **Important**, make sure to fill in the assignees, labels, projects and milestones fields of every issue to ensure proper tracking.

Create a feature branch with the naming scheme `feat-*`, make it short and descriptive.

> make sure you switch to the branch in your local repo after creating it

Proceed to make code changes and commit them regularly with good, descriptive commit messages in your local repo. If more than one person is working on the same branch, be sure to push your changes and pull others changes regularly.

> You may also wish to pull changes from `dev` at times if you want to test the newest updates against your feature branch

To merge your feature branch changes to the `dev` branch, create a PR and select at least one reviewer. **Important**, make sure to fill in the assignees, labels, projects and milestones fields of every issue to ensure proper tracking.

After the PR has been reviewed and any automated tests have been performed, the PR can be merged with `dev`. You can still work on a feature branch after it has had a completed PR, you just need to create a new one.

After enough changes have been made in `dev` we may decide to create a release branch with the naming convention `release-<VERSION-NUMBER>`. Release branches can only contain bug fixes and other small changes. Once the release is stable, a PR can be created to merge with `master`. PRs to `master` will be subject to the full set of automatic tests so that we ensure it is as stable as possible.

To summarise, the general process for contributing is as follows:

- Discuss the new feature on slack
- Create issues that cover the work you will do
- Create a feature branch
- Commit regularly and don't forget to push/pull changes
- Create a PR for the feature branch to the `dev` branch

### Project board management

The project board can be found [here](https://github.com/luslab/group-nextflow-clip/projects/1). It contains a list of all issues and PRs currently in the project. all newly created issues will be added to the `todo` column. These must be manually moved through the appropriate columns eventually ending in the `done` column.

All PRs are automatically added **and** moved along the board, there is no need to manually move them.

### Docker
This will be fleshed out soon but will contain details for how docker images are automatically built and how to manually run and test the pipeline.

### Slack
All changes to the project are communicated automatically by slack in the dev channel. This channel should be the centre for all information for the project.

### Running the pipeline on CAMP
To run the pipeline you first need to save your github credentials on CAMP to be able to access the private repos on luslab. Full details on configuring repo credentials can be found [here](https://www.nextflow.io/docs/latest/sharing.html). 

First go to your github settings and create a [personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line). Then create a config file to add your settings into on the CAMP login node.

```
nano $HOME/.nextflow/scm
```

Then fill the file with your username and access token string from github.

```
providers {

    github {
	user = 'luslab-user'
        password = '531ce109e288a017609a3852c1b3dda067cc9cef'
    }

}
```

Create a working environment for nextflow on CAMP by creating a folder structure in your CAMP storage folder specifically for nextflow runs. Then, create a run folder for each nextflow project.

Nextflow generates a lot of logging and config data during runs, which will fill up your storage on the login node. To mitigate this, run **ALL** nextflow runs from the CAMP storage mentioned above. Next, move your `.nextflow` config folder over to your nextflow CAMP storage folder and symlink back again.

```
mv ~/.nextflow/ /camp/lab/luscomben/PATH
ln -s /camp/lab/luscomben/PATH/.nextflow ~/.nextflow
```

Running nextflow on CAMP requires the loading of several modules and needs different syntax depending on what branch or profile of the pipeline you are running. There are some helper scripts in the repo which can be used directly or as a template for creating your own run scripts. These are located in `run_scripts/crick`. To use a run script, copy the file to your run folder on CAMP storage and type `./SCRIPT-NAME.sh`.

For instance, `run-example.sh` runs the whole pipeline on 4 samples which are described in `metadata-example.csv`. So you can copy `run-example.sh` and `metadata-example.csv` into your run folder and run this example analysis with the following command: `./run-example.sh`. It should take 15-20 minutes plus some time to pull the Singularity image if you are executing the pipeline in your run folder for the first time.

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE2OTU4NTY1NzhdfQ==
-->
