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

## User Stories (on MacOS X)

### Quick and Dirty

{% include note.html content="The **\"I only have 5 minutes and I want to do it quickly and dirty\"** approach. Just code a solution, drop couple data test files nearby, verify and measure, then throw everything away kind of approach." %}

* User installs Fate using Homebrew: `brew install fate`
* User creates a directory for his work: `mkdir foo`, `cd foo`
* User writes a runnable Python 3 script that solves some given algorithmic problem: `vim solution.py`
* User creates a couple files with input and output data to test the script against them: `vim input.dat`, `vim output.dat`
* User runs fate to test the solution against the test data files he created `fate`
* User runs fate to measure time and memory consumption of the solution `fate -tm`

### Structured and Neat

{% include note.html content="This approach covers development of several algorithms stored in different directories under the same project. Working on a **full set of solutions to HackerRank problems** is a good example of such approach." %}

* User installs Fate using Homebrew: `brew install fate`.
* User creates a directory for his solution, i.e. `hacker_rank/algorithms/graph_theory/roads_and_libraries/python_3/bfs_solution`.
* User already has a collection of test data files (input and output files to test the solution) in the `test_data` directory located at the `hacker_rank/algorithms/graph_theory/roads_and_libraries/test_data`.
* User writes a runnable Python 3 script that solves a given algorithmic problem: `vim solution.py`.
* User already has a fate config `fate.yaml` common for all solutions of the given problem: `hacker_rank/algorithms/graph_theory/roads_and_libraries/fate.yaml`. The config tells Fate about every input and output test data file.
* User runs fate to test the solution against the test data files he created `fate solution.py`.
* User runs fate to measure time and memory consumption of the solution `fate -tm solution.py`

## Use Cases

| Use Case | Description |
|-|-|
| **Setup.Brew** | Install Fate via Homebrew |
| **Setup.Pip** | Install Fate via PIP |
| **Test.Default** | Test solution with default parameters |
| **Test.Config** | Test solution with configured parameters |

## Fate's Logic
1. User runs `fate` in the directory
1. Fate reads arguments:

  1. If `1st` positional argument is present, then Fate will treat that string as a path to executable solution that has to be tested.

    * Note, that both relative and absolute paths are acceptable.
    * Usage examples: `fate solution.py`

  1. If `-i [--input]` named argument is present, then Fate will treat that string as a path to input data files.

    * Note, that both relative and absolute paths are acceptable.
    * Also the path can be a wildcard.
    * If `-i` argument is present, then `-o [--output]` path has to be present as well. The `-o` argument has same rules for path format as `-i` argument.
    * Usage example: `fate -i test_input* -o test_output*`. In this example Fate picks up first executable file and searches for all the matching pairs of `test_input*` and `test_output*` files in the current and in the `../test_data` directories.

  1. If `-t [--time]` named argument is present, then Fate will measure the execution time.
  Usage example: `fate -t`.
  1. If `-m [--memory]` named argument is present, then Fate will measure memory consumption.
  Usage example: `fate -m`.
  1. If `-r [--repeat]` named argument is present, then Fate will repeat the measurement for either time or memory `r` times.
  Usage example: `fate -t -r 10`.

1. Fate reads configuration files

  1. Fate reads `fate.yaml` config files starting from the current directory and up to the root directory.
  1. Low-level file rules always **overwrite** high-level config file rules, i.e. `/project/problem/solution/fate.yaml` config file has priority above `/project/problem/fate.yaml` config.
  1. If Fate didn't find a certain **required** rule in any of the `fate.yaml` files in the directory branch, then it tries to find these values in the `.faterc` config file in the current user's directory.
  1. TODO: Specify here how input/output pairs are configured.

1. Fate applies default rules when certain required rule was not found even in `.faterc` file.

  1. If `-i` and `-o` paths were not specified anywhere, then Fate looks for `input*` and `output*` group of matching files in current directory. Fate checks the `test_data*` directory in the parent directory, i.e. `../test_data*`. Fate considers an input and output files matching (and uses them) when wildcard parts in `input*` and `output*` are matching, i.e. `input_01.dat` and `output_01.dat`. If any of the files has no match Fate discards it.
  1. If `-r` amount of repeats was not specified anywhere, then Fate executes all input/output pairs **one time** by default.
  1. If path to executable solution is not specified anywhere, then Fate will search for the first executable file in the current directory following these rules:

    1. If platform is **Windows**: first (alphabetically) file with `.exe` extension.
    1. If platform is **\*nix**: first (alphabetically) executable file, as determined by Python3's `is_executable` function.

1. Fate executes given tasks


## Features

* Run unit tests in any directory of your project and see results (Run in Directory vs. Configurable Approach).
* Run any complied/interpretable solution against predefined set of input/output data.
* Measure performance of you compiled/interpretable solution using docker or just your machine.
* Depends on `fate.yaml` config in the current directory or any of the top directories
* Allows to save test results to file
* Allows to specify what input and output files to use
* Allows to use python data generators as input and output

HackerRank framework is a separate project that utilizes this project as a dependency and provides a structured collection of input/output tests along with published implementations in different languages as a reference.

## Principles

* Share acceptance test data (input and output) between solutions in different languages.
* Choosing and supporting a unit test framework for development is user's responsibility.
* Just do it approach to usage: user jumps into development of a solution by coding a quick draft and testing it against existing input/output tests using framework
* Installation via PIP
* Fate is not responsible for compiling the solution
* Fate is a Python program that tests solution by running it as a subprocess
* Solution can only consume data from standard input and only outputs answer to standard output
* Fate catches output to standard error stream and displays it
