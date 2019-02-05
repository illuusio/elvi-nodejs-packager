# Elvi - Generate Node JS package spec files for RPM packaging

Elvi is very **crude** packaging tool for generating Linux RPM SPEC files.
It doesn't do any node package fetching for that Elvi uses NPM.

To use this application one needs these tools:

   * Bash
   * NPM (Node package manager)
   * GNU tar
   * XZ Utils

## Basics

For Elvi one needs install all above tools. There is basic subset of NPMJS packages in
'package.txt'-file. elvi-fetch.sh gets wanted packages in packages-directory.
```
bin/elvi-fetch.sh
```
Currently Elvi script doesn't support global installation

## Template
For install able binary RPM template is (Currently targeted openSUSE):
```
template/node.spec
```
With no scrip there is template:
```
template/node-noscript.spec
```

## Pre-packaged RPMs for openSUSE
Most of these package can be found on repository
https://build.opensuse.org/project/show/home:illuusio:nodejs-packages

## Packages
Current package list is more or less CLI tools of Node libraries

 * atcss
 * autoprefixer
 * bower
 * clean-css-cli
 * colorguard
 * css2modernizr
 * csslint
 * css-mqpacker
 * cssnano-cli
 * doiuse
 * eslint
 * fixmyjs
 * fletch
 * grunt
 * grunt-cli
 * hexo-cli
 * immutable-css-cli
 * js-beautify
 * jshint
 * jsonlint
 * less
 * node-red
 * parcel-bundler
 * perfectionist
 * postcss-cli
 * prettier
 * rtlcss
 * srisum
 * stylefmt
 * stylehacks
 * stylelint
 * stylelint-config-standard
 * terser
 * uglifycss
 * uglify-js
 * web-ext
 * webpack
 * yarn
 * zxcvbn-cli

## How it works

Elvi fetches all dependencies of node package into directory and then build tar-package from
it. After that it tries to fetch NPM JSON package information and create RPM SPEC file from provided
information.

## Contributing
You can contribute with Pull Request or fail Issue. File package.txt tries to be in alphabetical order and
elvi-fetch.sh is check with [ShellCheck](https://github.com/koalaman/shellcheck) before merge.

License is MIT
   
## I don't have a clue what you just wrote

That is not you fault! Tool is targeted for very niche user space which is probably just me. 
