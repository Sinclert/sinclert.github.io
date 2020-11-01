---
title: "Terraform: benefits and setup"
layout: post
date: 2020-11-01 12:00
image: /assets/images-posts/terraform-logo.png
headerImage: true
tag:
- software
- infrastructure
- guide
category: blog
author: sinclert
description: "An introduction to Terraform, its benefits and basic setup"
---

## Index

- [Introduction](#introduction)
- [What is Terraform](#what-is-terraform-)
- [How to use Terraform](#how-to-use-terraform)
- [Benefits of Terraform](#benefits-of-using-terraform)
- [Automatic provisioning](#automatic-provisioning-)
- [Advanced topics](#advanced-topics)
- [Summary](#summary)


## Introduction
Within the world of software tools and frameworks, there is a category dedicated
to those that try to define physical infrastructure (servers, databases...) using code.

The magic to make this possible is to rely on a _Infrastructure as a Service_ provider
(IaaS), to expose the necessary APIs for us to programmatically communicate with them
and tell them what resources we want to have deployed.

This post aims to cover the basics of one of the _Infrastructure as code_ tools,
[Terraform][terraform-website], as long as its incredible benefits on the long run.


## What is Terraform? 🏗️
Terraform is a **command line** tool that allow developers to communicate with _IaaS_
cloud providers, in order to _manage_ resources within those providers. The Terraform
team usually refers to this _management_ of resources as both their **creation**,
and their **evolution** over time, covering every stage of their lifecycle:
creation, modification, and tear down.

The supported cloud providers, alongside their documentation, are:

- [Amazon AWS][terraform-aws-docs]
- [Google Cloud Platform][terraform-gcp-docs]
- [Microsoft Azure][terraform-azure-docs]
- [Oracle Cloud][terraform-oracle-docs]

For a deeper explanation, watch the [Introduction video][terraform-into-video]
by Armon Dadgar (HashiCorp CTO).

## How to use Terraform?
Terraform relies on the definition of resources by using one particular language
called _HashiCorp Configuration Language_ (HCL). This language allows developers
to define resources independently of the cloud provider.

It is said to be _"cloud agnostic"_.

HCL uses sets of key-values pairs to define particular properties within each
cloud resource. The _resource name_ dictates which keys are accepted, as different
providers allow different ways of configuring their resources.

For instance, this is an SQL Database definition within GCP:

```hcl
resource "google_sql_database" "us-database" {
  project  = "dummy-project"                # The GCP project targeted
  name     = "us-db"                        # The DB name we selected
  charset  = "UTF8"                         # The charset within the DB
  instance = "project-database-instance"    # Assuming this DB instance exists
}
```

Once there is a set of defined _resources_ using a specific _provider_,
the `terraform` CLI can be used to create a [State file][terraform-state-file].
This is the **most important file** from all the ones involved in the tool usage.

The state file (`terraform.tfstate`) maps real world resources to your configuration,
and it is used by Terraform when developers want to evolve an already existing
set of resources. In short, it is the **source of truth** of what has been created
within a cloud project.

If something is not in the state file, then it does not exist to Terraform.

Once a set of HCL files have been declared, using Terraform CLI involves:

1. Creating / getting the initial state: `terraform init`
2. Checking the diff between the HCL files and the state: `terraform plan`
2. Applying the diff between the HCL files and the state: `terraform apply`


## Benefits of using Terraform
You may be wondering why such a dedication to define cloud resources, given that
the _apparently easiest_ way to manage them is by using the Web UI all these providers offer.

Well, using the UI is **great to explore** and discover other products, but terrible
when it comes to change traceability, and evolution control.

### Change traceability
As anything associated with billing, it is important to know when infrastructure
changes occur, and by whom.

Bad news is, it is almost certain that your cloud provider does not offer a
complete history of changes for each resource. Even less, user name of who
performed each change.

Good news is: **we do not need it**. Thanks to the use of Terraform and the HCL language,
we can back up the HCL files within a GIT repository, already providing us the
complete list of changes since the creation of the repo. GIT to the rescue! 🚀

### Evolution control
Given the _source of truth_ role of the `terraform.tfstate` file, it is very common
to place this file in a centralized bucket (remote location), controlling who can and
cannot modify it.

For example, this is how to do it with a GCP bucket:

```hcl
terraform {
  backend "gcs" {
    bucket  = "terraform-bucket"        # Desired bucket name
    prefix  = "state"                   # Folders before the .tfstate file
  }
}
```

This **centralized** way of operating with Terraform allow teams to control how
changes are introduced by setting up a connection between their GIT platform
(i.e. GitHub), and the access to the remote bucket, so that **only PR reviewed
changes translate into real world infrastructure evolution**
(and to `.tfstate` changes along the way).

Trust me, centralized infrastructure control is a nice property to have 😌.


## Automatic provisioning 🤖
The logical next step upon having the Terraform resources within a GIT repository,
is to implement some kind of _Continuous Integration_ system to **automatize** how
code changes are propagated to real world infrastructure.

This automation is usually refer to as "_Automatic provisioning"_.

The main **challenges** of _automatic provisioning_ are two:

1. How is the Terraform repo C.I. going to authenticate with the cloud provider?
2. How is the Terraform repo C.I. going to be defined?

### Setup guide - CI Authentication
This section contains the specific guide of authenticating GitHub Actions runners
with a _Google Cloud Platform_ project. Please consider: the authentication may
work differently with other cloud providers.

1. Create a GCP project.
2. Create a _Service account_ (S.A.) within that project.
3. Give project `Owner` permissions to that S.A.
4. Create a _Service account key_ for that S.A.
5. Create a [GitHub secret][github-secret-docs] containing the key from step 4.

Later on, that _secret_ will be used to declare an env. variable called
`GOOGLE_APPLICATION_CREDENTIALS`, used to authenticate CLI tools with a GCP project,
according to the [GCP Authentication documentation][google-auth-docs].

### Setup guide - CI workflow
The last step involves creating a _GitHub Actions_ workflow that automatically
validates and applies Terraform changes upon PR merges.

A real world example may look like this:

```yaml
name: Terraform apply CI

on:
  push:
    branches:
      - master
    paths:
      - "project/**/*.tf"

env:
  HASHICORP_REPO_KEY: "https://apt.releases.hashicorp.com/gpg"
  HASHICORP_REPO_NAME: "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"
  TERRAFORM_LOCAL_PATH: "./project"


jobs:

  validate:
    needs: []
    runs-on: ubuntu-20.04
    steps:

      # ------ Set up Terraform CLI ------
      - name: "Set up GitHub Actions"
        uses: actions/checkout@v2
      - name: "Add HashiCorp GCP key"
        run: curl -fsSL ${HASHICORP_REPO_KEY} | sudo apt-key add -
      - name: "Add HashiCorp repository"
        run: sudo apt-add-repository "${HASHICORP_REPO_NAME}"
      - name: "Install package dependencies"
        run: sudo apt-get --yes install $(cat packages)

      # ------ Validate Terraform changes -----
      - name: "Initialize Terraform state"
        run: terraform init -backend=false ${TERRAFORM_LOCAL_PATH}
      - name: "Validate Terraform files"
        run: terraform validate ${TERRAFORM_LOCAL_PATH}


  apply:
    needs: [validate]
    runs-on: ubuntu-20.04
    env:
      PROJECT_SECRET_KEY: "${% raw  %}{{ secrets.GCP_PROJECT_SA_KEY }}{% endraw  %}"
      PROJECT_SECRET_PATH: "./project_key.json"

      # This env. variable is established across steps so that
      # Both 'init' and 'apply' commands can authenticate with GCP
      # Ref: https://cloud.google.com/docs/authentication/production
      GOOGLE_APPLICATION_CREDENTIALS: "./project_key.json"

    steps:

      # ------ Set up Terraform CLI ------
      - name: "Set up GitHub Actions"
        uses: actions/checkout@v2
      - name: "Add HashiCorp GCP key"
        run: curl -fsSL ${HASHICORP_REPO_KEY} | sudo apt-key add -
      - name: "Add HashiCorp repository"
        run: sudo apt-add-repository "${HASHICORP_REPO_NAME}"
      - name: "Install package dependencies"
        run: sudo apt-get --yes install $(cat packages)

      # ------ Set up GCP credentials ------
      - name: "Download GCP Service Account key"
        run: echo ${PROJECT_SECRET_KEY} > ${PROJECT_SECRET_PATH}

      # ------ Apply Terraform changes -----
      - name: "Initialize Terraform state"
        run: terraform init ${TERRAFORM_LOCAL_PATH}
      - name: "Apply Terraform changes"
        run: terraform apply -auto-approve ${TERRAFORM_LOCAL_PATH}
```

Clarifications for the workflow:

- It is only triggered upon `master` branch push (including PR merges).
- It is only triggered if a Terraform file is changed (`tf`).
- It assumes resources are defined within the folder `project`.
- It assumes the GitHub secret is called `GCP_PROJECT_SA_KEY`.
- Authentication works by setting the `GOOGLE_APPLICATION_CREDENTIALS`.


## Advanced topics
This blog post is limited and does not cover all the features of Terraform.

As some sort of _advanced topic_, I would suggest taking a look to the concept
of [**module**][terraform-module-docs]. A _module_ is nothing more than a packaged
version of a resource / set of resources, that can be imported from a _parent module_
in order to avoid duplication of definitions.

They become useful when defining very similar resources over an over again,
as they help developers to extract common specification and reduce code duplication.

In addition, there is a [public registry][terraform-module-list] of Terraform modules,
where different companies publish their curated ones (comparable to what _DockerHub_ is for Docker).
Modules from the public registry are often complex definitions of multiple resources,
so that they form a good architectural pattern (i.e. UI-Backend-DB pattern).


## Summary

Combining what the post cover, and the official Terraform documentation,
technical readers can achieve a good understanding of what Terraform is,
what are its main benefits, and how they can set up a basic pipeline to apply
_automatic provisioning_ in their cloud projects.

Terraform involves a time investment at first, but it pays off in the long run.
I hope this post helped you make that decision easier!


[google-auth-docs]: https://cloud.google.com/docs/authentication/production
[github-secret-docs]: https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets
[terraform-into-video]: https://www.youtube.com/watch?v=h970ZBgKINg
[terraform-aws-docs]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
[terraform-gcp-docs]: https://registry.terraform.io/providers/hashicorp/google/latest/docs
[terraform-azure-docs]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
[terraform-oracle-docs]: https://registry.terraform.io/providers/hashicorp/oci/latest/docs
[terraform-module-docs]: https://learn.hashicorp.com/tutorials/terraform/module
[terraform-module-list]: https://registry.terraform.io/browse/modules
[terraform-state-file]: https://www.terraform.io/docs/state/index.html
[terraform-website]: https://www.terraform.io
