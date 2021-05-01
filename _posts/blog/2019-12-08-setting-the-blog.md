---
title: "Guide to set up this blog :rocket:"
layout: post
date: 2019-12-08 17:00
image: /assets/images-posts/jekyll-logo.jpg
headerImage: true
tag:
- technology
- guide
- github
category: blog
author: sinclert
description: "A guide on how to set up Jekyll with GitHub pages to have a perfect blog"
---

## Introduction

This guide is aimed for people who do not know what Jekyll is, and have very or no experience with GitHub pages.

It is assumed that the reader knows Git, and GitHub beforehand.

#### Index
- [GitHub pages](#github-pages)
- [GitHub pages types](#github-pages-types)
- [GitHub pages organization](#github-pages-organization)
- [GitHub pages personalize](#github-pages-personalization)
- [Jekyll](#jekyll)
- [Jekyll themes](#jekyll-themes)
- [Jekyll organization](#jekyll-organization)
- [Summary](#summary)

---

## GitHub pages

GitHub offer developers to host a certain domain for themselves. This is really convenient when it comes to having
a personal website, blog, or simple web application without paying the necessary maintenance.

Every user on GitHub could have their own web under the `github.io` domain, by using their unique username as prefix,
resulting in `http://<username>.github.io` URLs. In order to use your free domain, you can follow GitHub's guide
available in [this post][github-pages].


### GitHub pages types

GitHub differentiates between different types of _pages_: organization / user ones, and project ones.

- **Organization / user pages:**
    - Description: pages to present or support basic information about and organization or an individual.
    - DNS visibility: Yes, it makes `https://<username>.github.io` available. 
    - Creation: using a project called `<username>.github.io` and organizing their contents there.
    - Structure:
        - Branch: **master** branch.
        - Files: organize all website files on the repository root folder, having `index.html` as entrypoint.
    
- **Project pages:**
    - Description: pages to include documentation or visual examples of a certain repository.
    - DNS visibility: No, these pages are attached to your personal domain: `https://<username>.github.io/<project>`. 
    - Creation: there are two options to make projects pages:
        - Structure A:
            - Branch: **master** branch.
            - Files: organize all website files within the `docs` folder.
        - Structure B:
            - Branch: **gh-pages** branch.
            - Files: organize all website files on the repository root folder.

Please, be aware the branches and folder names given in this part of the guide are _magic_ in the sense that
GitHub has specifically designed GitHub pages to work with those names. Do not change them.


### GitHub pages organization

As you can see, the pages organization is very clear (and constrained). GitHub is _forcing_ us to have a central repository
serving our personal domain, and for every project we want a custom page to appear on it, define either a `docs` folder
within the `master` branch, or a `gh-pages` branch with everything in their roots.

I find this way of organizing knowledge inconvenient, as the contents under the `https:<username>.github.io/` URL
is not available under the same repository, but among an unknown set of them.

An alternative solution will be proposed in this guide, under the [Jekyll](#jekyll) section. This same solution is
the one selected to run this blog as my personal web page :rocket:


### GitHub pages personalization

A final consideration about GitHub pages, is that it allow us to redirect traffic from a certain domain 
we have previously bought, to the one provided by GitHub. This can be useful to personalize our personal page URL, 
to something like `https://<username>.me` or `https://<username>.com`.

In order to do so, we need to create a `CNAME` file in the path where all the other website files are, indicating
the domain we had beforehand. You can follow GitHub's guide available in [this post][github-pages-custom-domain].


## Jekyll

Jekyll is a blog engine written in Ruby. It is [natively supported by GitHub pages][github-pages-with-jekyll], and can be
easily customizable by using public _themes_. It organized all its contents under a `_posts` folder, where each different
markdown document is a different post. The metadata of each post can differ from theme to theme.


### Jekyll themes

The theme customization can be done using one of the following methods:

A) Specifying a `theme` or a `remote_theme` within the Jekyll `_config.yml` file. Check out [native supported themes][jekyll-native-themes]

B) Using non GitHub-pages supported themes, just by following the theme authors README.

The option B is less scary than it seems, as there are incredible themes out there that can be easily set up by just forking
them into our personal account. Check out this wide list of [Jekyll themes][jekyll-all-themes]


### Jekyll organization

Jekyll way of organizing contents provides us a centralized repository ("`<username>.github.io`") to have a clean and organized
set of publications and project descriptions, without having to touch any of the existing projects in our GitHub account.
The use of the _markdown_ format on the posts provides no limitation to how we want to design our posts.

In addition, some Jekyll themes provide very useful sections such as _About_, _Projects_ or _Resume_, which can serve
as a fantastic presentation card for anyone entering our blog!


## Summary

We have explored GitHub pages and what it provides. We have also seen what Jekyll is, and how can it be integrated to the
domain GitHub offer us, to create a centralized location to manage our posts and projects descriptions.

This very own blog has been built **using these tools, and a very simple theme called [Indigo][jekyll-indigo-theme]!**

If you liked this post you can contact me on Twitter.
Happy blogging :)


[github-pages]: https://pages.github.com
[github-pages-custom-domain]: https://help.github.com/en/github/working-with-github-pages/about-custom-domains-and-github-pages
[github-pages-with-jekyll]: https://help.github.com/en/github/working-with-github-pages/creating-a-github-pages-site-with-jekyll
[jekyll-native-themes]: https://pages.github.com/themes/
[jekyll-all-themes]: http://jekyllthemes.org
[jekyll-indigo-theme]: https://github.com/sergiokopplin/indigo
