[![Build Status](https://travis-ci.org/idanarye/vim-makecfg.svg?branch=master)](https://travis-ci.org/idanarye/vim-makecfg)

INTRODUCTION
============

Vim'a `:make` command is simple and elegant, but requires the user to configure
their `makeprg` and `errorformat` options to the tool they want to use.
MakeCFG aims to be a database of these settings for various compilers,
interpreters and build tools. It contains a JSON file with data about the
different options, and basic API for using it.

MakeCFG hopes to get many tiny pull requests that add the settings of more and
more tools, so if the one you use is not in here yet - please add it to the
JSON and we'll try to approve the PR as soon as possible.

USAGE
=====

 * `:MCF <cfgname>` to set `&makeprg` and `&errorformat` to those defined by
   the selected tool:
   ```vim
   :MCF ant
   " Will run "ant":
   :make
   ```
 * `:MCF <cfgname> <command>` to set `&makeprg` and `&errorformat`, run the
   command, and then set them back.
   ```vim
   " Will run "ant":
   :MCF ant make
   ```
 * `makecfg#getOptions(<cfgname>)` to get the `&makeprg` and `&errorformat` in
   a Vim dictionary to use in your own plugin.
 * ([Omnipytent](https://github.com/idanarye/vim-omnipytent) extension) a
   context manager for setting `&makeprg` and `&errorformat` in Omnipytent tasks:
   ```python
   from omnipytent.ext.makecfg import makecfg

   with makecfg('ant'):
       # will run "ant":
       CMD.make()
   ```

VERSIONING(or lack thereof)
===========================

MakeCFG is a rolling release. The API is not going to change, and the only
updates are going to be settings for new tools. To avoid making a release every
time we get a new tool - we will not set a version.

If, in the future, the API will need to change - we may change this policy.
