---
title: "FATE – Framework for Algorithm TEsting"
keywords: homepage
sidebar: fate_sidebar
permalink: index.html
summary: >-
  Fate allows you to rapidly test and debug your algorithms: run acceptance tests against the set of input and output data files and measure their timings and memory consumption in an isolated environment.
---
## Overview

The framework provides a set of ready-to-use mechanisms to quickly test, and measure solutions for algorithmic programming problems.

The name is an acronym `FATE` – `F`ramework for `A`lgorithm `TE`sting.

## User Story (on MacOS X)

{% include note.html content="The **\"I only have 5 minutes and I want to do it quickly and dirty\"** approach. Just code a solution, drop couple data test files nearby, verify and measure, then throw everything away kind of approach." %}

* User installs Fate using Homebrew: `brew install fate`
* User creates a directory for his work: `mkdir foo`, `cd foo`
* User writes a runnable Python 3 script that solves some given algorithmic problem: `vim solution.py`
* User creates a couple files with input and output data to test the script against them: `vim input.dat`, `vim output.dat`
* User runs fate to test the solution against the test data files he created `fate solution.py`
* User runs fate to measure time and memory consumption of the solution `fate -tm solution.py`

### Features

* Run unit tests in any directory of your project and see results (Run in Directory vs. Configurable Approach).
* Run any complied/interpretable solution against predefined set of input/output data.
* Measure performance of you compiled/interpretable solution using docker or just your machine.
* Depends on `fate.yaml` config in the current directory or any of the top directories
* Allows to save test results to file
* Allows to specify what input and output files to use
* Allows to use python data generators as input and output

HackerRank framework is a separate project that utilizes this project as a dependency and provides a structured collection of input/output tests along with published implementations in different languages as a reference.

### Principles

* Share acceptance test data (input and output) between solutions in different languages.
* Choosing and supporting a unit test framework for development is user's responsibility.
* Just do it approach to usage: user jumps into development of a solution by coding a quick draft and testing it against existing input/output tests using framework
* Installation via PIP
* Fate is not responsible for compiling the solution
* Fate is a Python program that tests solution by running it as a subprocess
* Solution can only consume data from standard input and only outputs answer to standard output
* Fate catches output to standard error stream and displays it
