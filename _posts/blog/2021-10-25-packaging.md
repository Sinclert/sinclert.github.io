---
title: "📦 Python packaging: a simple overview"
layout: post
date: 2021-10-25 12:00
image: /assets/images-posts/package-index.png
headerImage: true
tag:
- software
- python
category: blog
author: sinclert
description: "A summary about the types of Python packages, their creation and distribution"
---

## Index

- [Introduction](#Introduction)
- [Packages: what are they](#packages-what-are-they)
- [Packages: what types are there](#packages-what-types-are-there)
  - [Source distribution](#source-distribution)
  - [Built distribution](#built-distribution)
  - [Why the distinction](#why-the-distinction)
- [Packages: how to create them](#packages-how-to-create-them)
- [Packages: how to distribute them](#packages-how-to-distribute-them)
  - [Distribution without an index](#distribution-without-an-index)
  - [Distribution with and index](#distribution-with-an-index)
- [Missing topics](#missing-topics)


## Introduction
The literature on how to create Python _packages_ has changed over the years.
It is quite diverse, and often lagged behind, given the age of Python and how the tooling
around the _encapsulation_ and _distribution_ of code have changed along those years.

This post tries to summarize how things state at **2021**, and to serve as a quick bootcamp
to anyone coming to Python from other languages.

**Note:** most of the presented information come from the learnings raised from the discussion
among other [IRIS-HEP][web-iris-hep] members and the amazing resources that they have created
for physicists to level up their Python game 🐍


## Packages: what are they
Within the Python world, the word _"package"_ generates some confusion.
In Python, that word can be applied to two different concepts interchangeably:

- A folder with a `__init__.py` file on it (file marking that folder as _importable_).
- A set of source files, and possibly data files, which get distributed, and hopefully installed, together.

The second concept is what other languages call _library_, and **it is the one covered in this post**.


## Packages: what types are there
Like other languages, Python have multiple types of distributables that can be generated from
a certain project. Each has a different connotation and could contain a different set of files.
They are:

- The _source distribution_ (`sdist` in short).
- The _built distribution_ (`bdist` in short).

There is a hierarchical relationship among the two, and among those two and
what is generally considered a project _repository_. The relationship can be
visualized as a collection of subsets:

![Package types](/assets/images-posts/package-index/package-types.png)


### Source distribution
A _source distribution_ is the minimal subset of files within a Python project repository
needed to create a _built distribution_ out of it.

It obviously contains all the source files (all the `.py` files), in addition to many others
that could be relevant for building the complete metadata of the package (`README.md`, `VERSION`, `LICENSE`...),
and a couple of special files where all the metadata, as well as the "instructions" on what to include in
the _built distribution_ are gathered: `setup.py` and / or `setup.cfg`.

These last two (`setup.py` and `setup.cfg`) have their names derived from [setuptools][repo-setuptools],
the long-lived library for package building being offered by the _Python Package Authority_ (PyPA).

Something to keep in mind: the PyPA is trying to make developers to move their metadata
and built distribution "instructions" from `setup.py` to `setup.cfg` as much as possible
(they can co-live). There are **many good reasons** for this, but I will not cover them in this post.
For more information, check [this Paul Ganssle article][post-setup-deprecated] on deprecating `setup.py`.


### Built distribution
A _built distribution_ is the set of files within a Python _source distribution_
needed to be installed on the end-user computer to offer all the desired functionality.

It contains all the source files (all the `.py` files), in addition to the package **full** metadata.

These _built distributions_ have taken different **formats** along the years. Many years ago,
they were distributed as _eggs_, and every _built distribution_ had the `.egg` extension.
Nowadays, most of them have migrated to the _wheel_ format (`.whl` extension),
by having the [wheel][repo-wheel] library installed, in the local environment, when building them.


### Why the distinction
One could ask: _why the distinction between source and built distributions?
just distribute the built one and get done with it_. Well, it is not that simple 😕.

In some cases, Python projects rely on underlying libraries, **written in other programming languages**,
that get bundled alongside them. In these cases (and some others) the translation between a _project_ and
a _built distribution_ is not that direct, as the compilation needed for those bundled libraries depends
on the target system (macOS / Linux / Windows, x64 / x32 / ARM architecture...).

To ease this problem, the _source distribution_ idea was introduced, by defining the minimal set of files,
that any developer need to have in order to create a _built distribution_ for any target system.


## Packages: how to create them
When considering how to create the distributions, the tooling has evolved in recent years.
Until recent times, [setuptools][repo-setuptools] was the almighty, all-powerful CLI tool.
It was used to (I) install, (II) test, (III) build and (IV) upload the packages.

_Those days are long gone_.

Nowadays, there are multiple tools to perform any of those actions, being most of them developed
and maintained by the [_Python Package Authority_][github-org-pypa] (PyPA).

When it comes to building the distributions, [build][repo-build] is the right tool for the job 🔧.
It can be easily used to create both the _source_ and the _built_ distributions for any pure-python project:

```shell
python -m build \
    --sdist \
    --wheel \
    --outdir dist \
    .
```


## Packages: how to distribute them
Finally, when it comes to distributing the packages, there are alternative ways to do so depending on
how much dependency towards third-party platforms developers want to assume.

### Distribution without an index
The simplest way of distributing Python packages (if they come from a version controlled repository),
is to rely on the functionality that [pip][repo-pip], the PyPA official tool for installing packages,
already provides.

_Pip_ is able to identify a tool identifier as suffix to the URL of the repository containing all the package code,
and use that tool to fetch the necessary code. There are some real-world examples within the
[Pip documentation][docs-pip-examples], but some of the most common ones are:

🔓 For **public** repos:
```shell
pip install git+https://github.com/<ORGANIZATION_NAME>/<REPOSITORY_NAME>.git@<COMMIT/TAG>
```

🔐 For **private** repos:
```shell
pip install git+ssh://git@github.com/<ORGANIZATION_NAME>/<REPOSITORY_NAME>.git@<COMMIT/TAG>
```

Please consider that in order to authenticate yourself with the repository hosting service (i.e. GitHub)
in order to download and install a **private** package, the public version of an _RSA_ pair of keys
must be set up as a [_Deploy key_][docs-github-keys] within the target repository.

### Distribution with an index
When relying on a _package index_, offered packages have been already built, and are ready to download.
This is preferable over the distribution of packages directly from a version controlled system,
given that, in those cases, the packages are being built _on-the-fly_.

The _Python Software Foundation_, in collaboration with some private partners, offer a **free** package index
for every developer to use, called [_Python Package Index_][web-pypi] (_PyPI_). This is the **main** index,
but not the only one, where users can fetch built packages from 🏗️.

From a developer perspective, they must perform some actions in order to distribute their packages:

1. Set up an account with [PyPI][web-pypi] (duh).
2. Have a procedure to create the distributions out of their repository (see [previous section](#packages-how-to-create-them)).
3. Have a procedure to upload the distributions to some _package index_.

For the case of PyPI, the best tool for uploading is [twine][repo-twine], which of course,
is also provided by PyPA. This CLI tool hides a lot of complexity by exposing a simple interface:

```shell
twine upload <PATH_TO_THE_DISTRIBUTIONS>/*
```

If a GitHub Action atomization is preferred instead, check out the [PyPI publish action][docs-actions-pypi]:
```yaml
name: Publish package

on:
  ...

jobs:
  publish:
    - ...
    - name: "Publish Python package"
      uses: pypa/gh-action-pypi-publish@v1.4.2
      with:
        user: __token__
        password: {% raw %}${{ secrets.PYPI_API_TOKEN }}{% endraw %}  # Your PyPI auth token
        verify_metadata: true
```


## Missing topics
This post aimed to provide a high-level summarized overview of Python packages and the logistics surrounding them.
There are many aspects and peculiarities not covered. For a complete explanation, check out
the [official documentation](https://packaging.python.org/).

Please, consider that the tooling around the encapsulation and distribution of packages has changed **a lot**
throughout the history of Python, so you may find old blog posts talking about:

- The `easy_install` tool.
- The `.egg` format.
- The `distutils` library.
- _How great_ it is to invoke `setup.py` directly (`python setup.py <command>`)
- ...

Most of these concepts / tools are considered **legacy** as of **2021**.


[docs-actions-pypi]: https://github.com/marketplace/actions/pypi-publish
[docs-github-keys]: https://docs.github.com/en/developers/overview/managing-deploy-keys
[docs-pip-examples]: https://pip.pypa.io/en/stable/cli/pip_install/#examples
[github-org-pypa]: https://github.com/pypa
[post-setup-deprecated]: https://blog.ganssle.io/articles/2021/10/setup-py-deprecated.html
[repo-build]: https://github.com/pypa/build
[repo-pip]: https://github.com/pypa/pip
[repo-setuptools]: https://github.com/pypa/setuptools
[repo-twine]: https://github.com/pypa/twine
[repo-wheel]: https://github.com/pypa/wheel
[web-iris-hep]: https://iris-hep.org/
[web-pypi]: https://pypi.org/
