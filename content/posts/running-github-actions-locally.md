---
title: "Running Github Actions Locally"
date: 2021-04-29T17:58:48+05:30
draft: true
toc: true
images:
tags:
  - devops
  - github
---
---
Actions are usually developed in the GitHub repository where the project itself is hosted. It is often required to modify these workflows multiple times during its development. This requires a commit to the repo everytime to execute/trigger these workflows.

---

## ACT

ACT is an opensource project that allows us to test these github workflows locally rather than updating the workflow file directly on the github repository.

Refer README for the installation of act.

https://github.com/nektos/act

## Handling Secrets

Secrets can be parsed as commandline arguments or as a dedicated file which holds the variables for the workflow. Secrets file has list of variables and associated values in `variable=value` form.

![image-20210429173740422](https://raw.githubusercontent.com/corestackdev/images/main/image-20210429173740422.png)



## Runner Image

Most images from docker hub are capable of running the workflows. Runner defined in the workflow file can be superseeded by a custom docker image as an argument in CLI.

## Execution/Testing the Workflow

Start by cloning the github repository where the github actions are created.

```sh
$ git clone <git url>
```

Change directory to the cloned git path and execute the runner

```sh
$ act -r --secret-file ~/dev/act/secrets -P self-hosted=karthickk/github-runner:latest
```

- -r - enable re-using the same docker image for successive runs
- --secret-file - file which holds the secrets
- self-hosted - is the referenced runner in my workflow file which is overriden by a docker hub image (karthickk/github-runner:latest)

## Limitations

The workflows runs against the latest commit code. GitHub actions cannot be triggered based on a commit ID. However, below is a workaround to run the workflow/action against a  specific commit.

```sh
$ cd <git cloned path>
$ git reset –hard <commit-hash>
$ act -r --secret-file ~/dev/act/secrets -P self-hosted=karthickk/github-runner:latest
```
