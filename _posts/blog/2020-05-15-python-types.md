---
title: "Python type hints: a guide"
layout: post
date: 2020-05-15 20:00
image: /assets/images-posts/mypy-logo.png
headerImage: true
tag:
- software
- python
category: blog
author: sinclert
description: "Personal decision process on how to use Python type hints"
---


## Introduction

Python annotations has been around since Python 3.0. They were first introduced
without any specific purpose in [PEP 3107][python-pep-3107], but it was not
until Python 3.5 and [PEP 484][python-pep-0484] that their real purpose was defined:
type hinting.

Type hints are used to specify types in functions signatures and variable definitions,
to avoid unintended error when programming in a dynamic-typed language such as python 🐍.

### Why are they useful

People usually love Python because of its clear syntax, and lack of verbosity.
When Type hints were introduced through the `typing` package, they were designed
to be flexible enough:

1. To allow a gradual usage throughout your code base.
2. To allow users decide the level of verbosity:

```python
from typing import Dict
from typing import List

# Option A
def foo(param: list):
    pass

# Option B
def foo(param: List[dict]):
    pass

# Option C
def foo(param: List[Dict[str, int]]):
    pass
```

In addition, these type annotations **do not affect run-time execution**,
as they are only checked when the code is seating idle, and a _static type analyzer_ 
is run (more on type analyzers later on).

Be aware, type annotations **do not prevent wrong types to be used at run-time**,
however, when a codebase has concrete enough type annotations, and it is compliant
with a mature enough _static type analyzer_, you can be fairly sure it won't happen 😌.

### How you should use them

As mentioned before, flexibility is the key word here. You should use them in the way
that you feel the most comfortable.

In my opinion, they should be always be used in functions and class attributes,
but not on common variables. The reason for this logic is that classes and functions
have a _"contract"_ nature inherent to them, that scope specific variables do not.


## Static type analyzers

Defining all those type hints is great, and it could help new programmers
to faster understand what a given function is doing. However, they need
a _static analyzer_ tool to be truly useful.

An additional argument to show the need for a _static analyzer_, is the fact that
not all IDEs have a _type watcher_ tool built in. I personally use [PyCharm][pycharm-website],
which highlights as warning any type misaligned it encounters, but there are others
not-so-complete IDEs that do not provide these automatic checks (VSCode, SublimeText...)

### What type analyzers exist

There are several static type analyzers for Python out there. From a quick search
on May 2020, it seems there are four of them getting more traction across the community
(coincidentally created by the biggest players in the tech. world):

- [Python/mypy][mypy-repository] (~8500 🌟).
- [Microsoft/pyright][pyright-repository] (~5100 🌟).
- [Facebook/pyre][pyre-repository] (~3400 🌟).
- [Google/pytype][pytype-repository] (~2700 🌟).

It is cool to discover that community traction is one of those fields where
[Zipf's law][zipf-law-article] also applies! For more context, please watch
[Vsauce Zipf law video][zipf-law-video]{:target="_blank"}, it is truly amazing.

### How to choose a type analyzer

All the candidates from the previous section seem mature enough (due to the number
of starts), and well-supported enough (due to the organization holding them),
to be chosen as our primary option without any regrets.

In my particular case, I considered the following criteria:
- Good documentation.
- Python _nativeness_.
- Level of personalization.
- Standard config file (either `ini` or `toml`).
- [Pre-commit][pre-commit-website] support.

After considering all the candidates, I decided for **Mypy** because:
- It is the one with the biggest traction.
- It offers a [very high level of personalization][mypy-cli-docs].
- It will soon add [support for toml configuration files][mypy-toml-issue].
- It has a [pre-commit hook][pre-commit-mypy].


## My choice: Mypy

This section considers that you have also chosen Mypy as your static analyzer of choice.
If not, then you have reached the end of this post.

### Configuring Mypy

When configuring _how_ to run Mypy, I recommend using the following flags:
- `--allow-redefinition`: to allow variable definition (useful in small scopes).
- `--ignore-missing-imports`: to avoid type checking dependency packages.
- `--cache-dir=/dev/null`: to avoid generating a cache on each run.

### Some considerations

Even if Mypy has reached a relatively good maturity level, there are still
some open issues which may annoy you when defining advanced typing hints:

- [Issue 1][mypy-abc-issue]: ABC typed variables being assigned a subclass object.
- [Issue 2][mypy-star-issue]: star expansion used next to a keyword argument.

Finally, the use of its pre-commit hook is very valuable to ensure that our
mypy-compliant project remains that way in the future. Just consider that
you may need to use the `pass_filenames: false` option if there are multiple
modules with the same name.

An example Mypy pre-commit hook could look like this:

```yaml
-   repo: https://github.com/pre-commit/mirrors-mypy
    rev: v0.770
    hooks:
    -   id: mypy
        name: "Python types analyzer (source)"
        args: ["--allow-redefinition", "--ignore-missing-imports", "--cache-dir=/dev/null", "src"]
        language: python
        pass_filenames: false
```


## Conclusions

Python type hints are improve the quality of any Python projects,
and you should definitely use them when starting a project from scratch.

For already existing project, the approach to add hints needs to be more flexible,
as it could be unfeasible to type everything on one sitting.
Thankfully, static type analyzers allow us to flexibly define them.

Choose your favourite static analyzer and start coding 🚀.


[mypy-cli-docs]: https://mypy.readthedocs.io/en/stable/command_line.html
[mypy-abc-issue]: https://github.com/python/mypy/issues/4717
[mypy-star-issue]: https://github.com/python/mypy/issues/6799
[mypy-toml-issue]: https://github.com/python/mypy/issues/5205

[pre-commit-mypy]: https://github.com/pre-commit/mirrors-mypy
[pre-commit-website]: https://pre-commit.com

[pycharm-website]: https://www.jetbrains.com/pycharm
[python-pep-3107]: https://www.python.org/dev/peps/pep-3107
[python-pep-0484]: https://www.python.org/dev/peps/pep-0484
[Learn Python Programming]: https://www.scaler.com/topics/python/

[mypy-repository]: https://github.com/python/mypy
[pyright-repository]: https://github.com/Microsoft/pyright
[pyre-repository]: https://github.com/facebook/pyre-check
[pytype-repository]: https://github.com/google/pytype

[zipf-law-article]: https://en.wikipedia.org/wiki/Zipf%27s_law
[zipf-law-video]: https://www.youtube.com/watch?v=fCn8zs912OE
