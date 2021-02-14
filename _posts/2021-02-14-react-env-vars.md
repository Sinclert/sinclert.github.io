---
title: "The obscure injection of values into built React apps"
layout: post
date: 2021-02-14 16:00
image: /assets/images-posts/webpack-transform.png
headerImage: true
tag:
- software
- react
- devops
category: blog
author: sinclert
description: "A guide of how to inject environment variables into built React apps"
---

## Index

- [Introduction](#introduction)
- [Context](#context)
- [Misconceptions](#common-misconceptions)
- [Proposed solution](#proposed-solution)
- [Bonus: Docker](#bonus-docker-)
- [Summary](#summary)
- [Final notes](#final-notes)


## Introduction
Using React to develop web applications is great. Both the framework simplicity and
the wide ecosystem of packages makes React the dominant player when it comes to
creating _Single Page Applications_ (SPAs) ⚛️.

With the recent popularity of DevOps tools, and the ease for automatized deployments,
the injection of _runtime-specified_ application-level values has become crucial,
whether these values determine logging level of the app, or the URL where a certain API is hosted.
On this context, **the absence of a mechanism to inject values to _built_ React applications**
at _runtime_, has become a problem.

This post covers the common misunderstandings around this topic, and presents a solution.

_**Disclaimer: I am not a React expert, so there may be some space for improvement here and there.**_


## Context
In order to understand the specific scenario where the React limitation is located, some context is required.
In case you already know what a _built_ React application is, and what point in time the word _runtime_
refers to, please, jump into the [proposed solution section][section-solution].

### What is a built React app? 📦
Simply put, _built_ React application is the result of the use of [Webpack][webpack-web] to bundle together
all the different assets that a React project may defined (`.js`, `.css`, `sass`, `.png` files...),
to generate a small group of compressed equivalents (usually called _bundles_). The distribution of
these _bundles_ increase the performance of the web applications,  as their size is smaller than
the original assets.

All React applications bootstrapped using the [create-react-app tool][cra-web] implicitly include Webpack as
the _bundling_ engine every time the developers use `react-scripts build` (or their shortcut `npm build`).

### What is _runtime_ referring to? ⚙️
The word _runtime_ makes reference to the point in time, within the lifecycle of the application, where
the application is just about to be executed. This is different from the commonly known _build-time_,
which makes reference to where the application is _built_ and _optimized_ (using Webpack, encapsulating the
application on a Docker image, or both).

As an example, _runtime_ refers to when a developer runs any of these start commands:

```sh
# Launch the app before being built (development mode)
$ npm start
# Launch the app after being built (production mode)
$ serve -s 'build'
# Launch the app from within a Docker image
$ docker run <IMAGE_NAME>:<IMAGE_VERSION>
```

### Where is the limitation located?
As stated before, React **does not** have a mechanism to inject specific values into a _built_ application
at _runtime_. At that point in time, the _bundles_ would have been already generated, and any change to their
contents would require the developer to **re-build** the application.

It **does have**, however, a way of injecting values when an application has not been _built_ yet,
by the use of the `REACT_APP_<VARIABLE_NAME>` environment variables, which are available though the use of
the `process.env.REACT_APP_<VARIABLE_NAME>` within the application JavaScript. This mechanism is documented
in the _Add custom environment variable_ section of the [React documentation][cra-env-variables]


## Common misconceptions
Through the internet, there are a bunch of blog articles commenting, very briefly, how the use of
`REACT_APP_<VARIABLE_NAME>` environment variables can be used to inject values into your React application.

What they fail to clarify is that, this approach is only valid when we are launching the application
in _development_ mode, and therefore, before building any kind of optimized bundle out of it.

Some **misleading** articles examples are:
- [_Adding env vars to your app_][article-env-vars-1]: which does not cover the injection on _built_ apps.
- [_Using env vars in React_][article-env-vars-2]: which does not cover the injection on _runtime_, only _built-time_.

Quoting the official React documentation:
> _The environment variables are embedded during the build time._
> _Since Create React App produces a static HTML/CSS/JS bundle, it can’t possibly read them at runtime_

![Built apps meme](/assets/images-posts/react-env/one-does-not-simply-meme.jpg)


## Proposed solution
The proposed solution has been inspired from [this fantastic article][article-env-vars-3] by Krunoslav Banovac.
The article explains the injection of environment variables into a _built_ React application, through the use
of a light-weigh shell script executed just before running the main application. The script makes the injected
values available through the use of the `window.env` JavaScript object.

The article also contains some non-related _Nginx_ configuration steps. Those will be avoided during this explanation.

### Step 1: Creation of an .env file
The first step is to create an `.env` file at the root of the project. The name of the file is just a convention,
but any name would do. This file will be in charge of storing the list of environment variables that will be
parsed and injected.

An example may be:
```text
API_SERVER_HOST=http://0.0.0.0
API_SERVER_PORT=8080
```

### Step 2: Creation of the parsing script
Then, an _environment-parsing_ script is necessary to harvest any env. variable available at _runtime_.
This script will search for those env. variables defined in the `.env` file, overriding their default values
with the ones the developer may have manually defined.

This is the proposed script:
```shell
#!/bin/sh

### NOTE:
###
### Script that parses every variable defined in the source file
### in order to replace the default values with environment values,
### and dump them into a JavaScript file that gets loaded by the app.
###
### Arguments:
### --destination: Destination folder within the project root (i.e. public).
### --output_file: Name of the run-time generated output JavaScript file.
### --source_file: Name of the source file to read variables names from.

# Define default values
destination="build"
output_file="environment.js"
source_file=".env"

# Argument parsing
while [ "$#" -gt 0 ]; do
    case $1 in
        -d|--destination)  destination=${2};     shift  ;;
        -o|--output_file)  output_file=${2};     shift  ;;
        -s|--source_file)  source_file=${2};     shift  ;;
        *) echo "Unknown parameter passed: $1";  exit 1 ;;
    esac
    shift
done


PROJECT_DIR="$(dirname "$0")/.."

# Define file paths
OUTPUT_PATH="${PROJECT_DIR}/${destination}/${output_file}"
SOURCE_PATH="${PROJECT_DIR}/${source_file}"

# Define AWK expressions to parse file and get env. vars
AWK_PAD_EXP="\"    \""
AWK_KEY_EXP="\$1"
AWK_VAL_EXP="(ENVIRON[\$1] ? ENVIRON[\$1] : \$2)"
AWK_ALL_EXP="{ print ${AWK_PAD_EXP} ${AWK_KEY_EXP} \": '\" ${AWK_VAL_EXP} \"',\" }"


# Build the run-time generated JavaScript environment file
echo "window.env = {" > "${OUTPUT_PATH}"
awk -F "=" "${AWK_ALL_EXP}" "${SOURCE_PATH}" >> "${OUTPUT_PATH}"
echo "}" >> "${OUTPUT_PATH}"
```

As you can see, the script can be parametrized:
- `--destination`: folder to place the output file. By default `build`.
- `--output`: name for the resulting output file. By default `environment.js`.
- `--source_env`: file defining the env. variable defaults. By default `.env`.

### Step 3: Add import to index.html
Finally, we need to import the parsing output file into our application. This will require to modify the
`public/index.html` file, the one serving as canvas to which the React components are attached.

Modify `index.html` to add the following line:
```html
<html>
    <head>
        ...
        <!--
            The file 'environment.js' provides run-time values being propagated by the user.
            It only exists at run-time, when 'parse-env.sh' is called before starting the server.
        -->
        <script type="text/javascript" src="%PUBLIC_URL%/environment.js"></script>
        ...
    </head>
```

### Optional changes
Event though at this point we have done all the necessary changes to inject environment values into 
a _built_ React application at _runtime_, there are a couple of optional changes to make this approach
even more convenient.

Up to now, this mechanism is applied when we manually run the `parse-env.sh` shell script before launching
the application. For example:

```shell
./scripts/parse-env.sh && serve -s 'build'
```

However, what happens with the _development_ mode? Could we automatically run that script when we are testing
a pre-built application, so that we have a consistent value-injecting mechanism to both _development_ (pre-built)
and _production_ (built) scenarios?

**Yes, we can**. Let me introduced you to the `prestart` rule within the `scripts` section of the `package.json` file.
That rule is used to specify a given set of commands implicitly run before the classic `npm start`. In this case,
just modify the file and add:

```json
{
  "scripts": {
    "prestart": "./scripts/parse-env.sh --destination public"
  }        
}
```

_Note: noticed how, in this case, the destination has been set to `public`, which is where development mode
run applications put their `index.html` canvas file._

Last but not least, add the parsing script output file to the `.gitignore` list. This is not a file worth
committing, as it will be generated _on-the-fly_, everytime we launch the application in development mode.


## Bonus: Docker 🐋
Docker is one of the driving forces of this _runtime injection_ requirement. This containerization technology
encourage us to have an optimized and built version of our application (a Docker image), before running it
elsewhere. For this reason, the implementation of the proposed _runtime_ injection mechanism directly addresses
the injection of environment variables into Dockerized React applications.

To integrate the described procedure with an already defined `Dockerfile`, just:

1. Copy the `scripts` folder to the image.
2. Change the container launching command to include `./scripts/parse-env.sh`.
3. Add the parsing script output file to the `.dockerignore` (it may cause bugs otherwise).


## Summary
This blog post introduces a standardized and _mode-wide_ consistent mechanism to inject user-defined values
into _built_ React applications. In addition, it helps clarify common misconceptions that entry-level
developers may have about how React makes certain env. variable values available within `process.env`
(which **only applies to pre-built applications**).

The proposed solution generates an _on-the-fly_ `environment.js` file, harvesting environment variables from
the _runtime_ environment, to override the default `.env` values. At the end, this generated file is imported
into the application through the use of a `<script>` tag within `index.html`.


## Final notes
I would love to hear from experienced React developers. How do you fight this limitation?
Do you use any simplified procedure to achieve the same goals?

Let me know at 🐦 [@Sinclert_95][twitter-sinclert].


[article-env-vars-1]: https://medium.com/datadriveninvestor/how-to-add-custom-environment-variables-to-your-create-react-app-6c336e081075
[article-env-vars-2]: https://trekinbami.medium.com/using-environment-variables-in-react-6b0a99d83cf5
[article-env-vars-3]: https://www.freecodecamp.org/news/how-to-implement-runtime-environment-variables-with-create-react-app-docker-and-nginx-7f9d42a91d70/
[cra-env-variables]: https://create-react-app.dev/docs/adding-custom-environment-variables/
[cra-web]: https://create-react-app.dev/
[section-solution]: #proposed-solution
[twitter-sinclert]: https://twitter.com/sinclert_95
[webpack-web]: https://webpack.js.org/
