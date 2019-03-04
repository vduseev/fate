---
title: "Fate – Framework for Algorithm TEsting"
keywords: homepage
sidebar: fate_sidebar
permalink: index.html
summary: >-
  Fate allows you to rapidly test and debug your algorithms: run acceptance tests against the set of input and output data files and measure their timings and memory consumption in an isolated environment.
---
## Overview

The framework provides a set of ready-to-use mechanisms to quickly test, and measure solutions for algorithmic programming problems.

The name is an acronym `Fate` – `F`ramework for `A`lgorithm `TE`sting.

In its simplest configuration Fate runs an executable file as a child process and feeds it the contents of one input file, then compares the output of the executable with the output file. If test has passed Fate proudly reports it to the standard output. If test has failed Fate reports the details of failure such as exact line in the output file that did not match the output of the executable.

When several pairs of input and output files are given using wildcard or a list in configuration file, then Fate performs as many tests as there are pairs of input and output files.

{% include note.html content="Time measurement and Memory measurement are planned for `2018.Q2` release." %}


## Features

* Run unit tests in any directory of your project and see results (Run in Directory vs. Configurable Approach).
* Run any complied/interpretable solution against predefined set of input/output data.
* Measure performance of you compiled/interpretable solution using docker or just your machine.
* Depends on `fate.yaml` config in the current directory or any of the top directories.
* Installation via PIP, Homebrew, downloaded package, and repository clone.
* Allows to save test results to file.
* Allows to specify what input and output files to use.
* Allows to use python data generators as input and output.

HackerRank Challenge is a separate project that utilizes Fate as a dependency and provides a structured collection of input/output tests along with the solutions to HackerRank problems in different languages as a reference.

## Principles

* Share acceptance test data (input and output) between solutions in different languages.
* Choosing and supporting a language-specific unit test framework for development is user's responsibility.
* Just do it approach to usage: user jumps into development of a solution by coding a quick draft and testing it against existing input/output tests using framework
* Fate is not responsible for compiling the solution.
* Fate is a Python program that tests solution by running it as a subprocess.
* Solution can only consume data from standard input and only outputs answer to standard output.
* Fate catches output to standard error stream and displays it.
