---
title: "GitHub automations: Dependabot"
layout: post
date: 2021-06-25 12:00
image: /assets/images-posts/robot-icon.png
headerImage: true
tag:
- software
- github
category: blog 
author: sinclert
description: "An introduction to dependabot, GitHub automation to deal with versioned artifacts"
---

## Index

- [Introduction](#introduction)
- [A bit of history](#a-bit-of-history)
- [How does it work](#how-does-it-work)
- [Examples](#examples)
- [Summary](#summary)


## Introduction
[GitHub's dependabot][dependabot-web] is an automation available to all GitHub repositories, providing
automatic updates on most common versioned artifacts. _Artifacts_ is a purposely chosen word here,
as the word _dependencies_ could imply software packages installed by some sort of package manager
(npm, pip, bundle...). However, the functionality of _dependabot_ goes further than that.

This article explains a bit of history over this great feature, to what extent it could be used on your
personal / professional projects, and some real examples on how to use it.


## A bit of history

### The beginning
_Dependabot_ started as a way to automatically create _Pull Requests_ to repositories depending on a certain
software package (over a wide range of programming languages). The idea was that, if a security vulnerability
was found on a popular package, all applications depending on that package should be notified.

The only enabling option to be part of these **autonomous security scans** is located on the _⚙️ Settings_ page
of each repository. There, you could activate _"Dependabot security alerts"_ (which automatically enables
_"Dependency graph"_ and _"Dependabot alerts"_ options).

![Security scan options](/assets/images-posts/dependabot/dependabot-security-opts.png)

### Evolution
Eventually, _dependabot_ evolved into a **multi-purpose automatic updater**, leaving behind security as its
only scope. For more information about this launch and how GitHub explains it, please check the following
entry on their blog: [_Keep all your packages up to date with Dependabot_][dependabot-evolution-blog] (2020).

This was the biggest step since its creation, and what enabled us today to enjoy the convenient revision
of versioned artifacts within our projects.

Note how the referenced article mentioned a difference between a so-called _dependabot-preview_ and
_dependabot-native_. In my experience, this difference does not exist anymore, as all _Pull Requests_
(both from security scans, and from multi-purposed version updates) are done from the same _agent_.

### Current situation (2021)
Nowadays, _dependabot_ functions as a free automation, providing two independent services:

- [Security scans][dependabot-security-guide], enabled via repository settings.
- [Artifacts auto-updates][dependabot-updates-guide], activated by defining a `.github/dependabot.yml` file.

The latter is the most customizable of them both, as there is [a given syntax][dependabot-updates-syntax]
that you could use to tune those _artifact auto-updates_ to the repository needs. These version updates
could be applied to everything from a package dependency (npm, pip, bundle...) to a Docker base image,
to Terraform modules, to GitHub Actions, to, one of my favourites: [GIT submodules][submodules-guide].

**Thus, the _artifact_ auto-updates naming.**


## How does it work
Each of the different package managers / system artifacts covered by _dependabot_ automations has its own
rules on which files to monitor, and can be configured on what strategy to apply when updating
(`increment` vs `wide` vs ...), what types of dependencies to ignore, etc.

As an example, when the `dependabot.yml` is configured to monitor `pip` packages, _dependabot_ parses:

- All `requirements-*.txt` files.
- Both `setup.py` and `setup.cfg` files.
- Project `pyproject.toml` file.

In order to see which repository files are being monitored by the `dependabot.yml` configuration,
navigate to the _📈 Insights_ tab and click on _Dependency graph_ ➡️ _Dependabot_. As an example,
this is how a JavaScript project, where both `npm` and `github-actions` versioned artifacts are
included into the configuration, looks like:

![Dependabot parsed files](/assets/images-posts/dependabot/dependabot-parsed-files.png)


## Examples
On a personal note, I see this "artifacts auto-update" functionality as a way to automatize
the boring process of patching artifacts due to bug fixes releases, or performance improvements.
That's it. Configuring _dependabot_ to automatically update _every_ artifact in a repository, to _any_
higher version is a **bad idea**, as it could lead to breaking changes being mistakenly introduced
in your project.

The fact that we _could_ do it does not make it good. **We must be smart about it**.

On this regard, there are two `dependabot.yml` configuration options that are extremely useful:

- The `ignore` section: which could be configured to ignore [Semantic versioned][semantic-version-web]
  artifacts _major_, _minor_, and _patch_ upgrades.
- The `allow` section: which could be configured to allow auto-updates on specific sets of dependencies
  (_production_ vs _development_).
  
A real example using these options may look as follows:

```yaml
version: 2

updates:
  - package-ecosystem: pip
    directory: "/"
    # Perform auto-updates weekly (Mondays by default)
    schedule:
      interval: weekly
    # Ignore auto-updates on SemVer major releases
    ignore:
      - dependency-name: "*"
        update-types: ["version-update:semver-major"]
    # Allow auto-updates on both prod and dev packages
    allow:
      - dependency-type: development
      - dependency-type: production
```


## Summary
GitHub _dependabot_ provides a fantastic automation to relief some pain when keeping up with _artifact_ patches
on our code repositories. It covers a wide variety of package managers, marketplaces (like _GitHub Actions_
or _Terraform modules_), and miscellaneous versioned systems; each of them configurable through a common syntax.

Easy to configure, free to use, multi-language supported...

You got this dependabot! 💙


[dependabot-web]: https://dependabot.com/
[dependabot-evolution-blog]: https://github.blog/2020-06-01-keep-all-your-packages-up-to-date-with-dependabot/
[dependabot-security-guide]: https://docs.github.com/en/code-security/supply-chain-security/managing-vulnerabilities-in-your-projects-dependencies/about-dependabot-security-updates
[dependabot-updates-guide]: https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates
[dependabot-updates-syntax]: https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates#configuration-options-for-updates
[semantic-version-web]: https://semver.org/
[submodules-guide]: https://git-scm.com/book/en/v2/Git-Tools-Submodules
