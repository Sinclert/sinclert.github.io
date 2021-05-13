# Personal blog

This repository contains my personal blog, created using Jekyll for the content management,
and GitHub pages for the blog hosting. A complete guide on how to do set it up can be found
at [this GitHub tutorial][github-pages-jekyll].

For more detailed information about how you can make your blog looks different (apply a theme),
or how the GitHub pages hosting can be integrated with project-specific websites, check out
my [very first blog post][blog-setting-up-post].


## Local environment
To locally deploy the website, install the Jekyll related dependencies by doing:

```shell
bundle config set path "vendor/bundle"
bundle install
```

Then you can either:
- **Deploy** the application executing `scripts/deploy.sh`.
- **Test** the application executing `scripts/test.sh`.


## Public access
The blog is publicly available on [sinclert.github.io/blog][blog-url].


[blog-url]: https://sinclert.github.io/blog/
[blog-setting-up-post]: https://sinclert.github.io/setting-the-blog/
[github-pages-jekyll]: https://help.github.com/en/github/working-with-github-pages/creating-a-github-pages-site-with-jekyll
