---
title: "Use Cases"
keywords: use case
sidebar: fate_sidebar
permalink: use_cases.html
summary: >-
  This page describes use cases and usage examples.
---
## User Stories (on MacOS X)

### Quick and Dirty

{% include note.html content="The `\"I only have 5 minutes and I want to do it quickly and dirty\"` approach. Just code a solution, drop couple data test files nearby, verify and measure, then throw everything away kind of approach." %}

* User installs Fate using Homebrew: `brew install fate`
* User creates a directory for his work: `mkdir foo`, `cd foo`
* User writes a runnable Python 3 script that solves some given algorithmic problem: `vim solution.py`
* User creates a couple files with input and output data to test the script against them: `vim input.dat`, `vim output.dat`
* User runs fate to test the solution against the test data files he created `fate`
* User runs fate to measure time and memory consumption of the solution `fate -tm`

### Structured and Neat

{% include note.html content="This approach covers development of several algorithms stored in different directories under the same project. Working on a `full set of solutions to HackerRank problems` is a good example of such approach." %}

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
| `Setup.Brew` | Install Fate via Homebrew |
| `Setup.Pip` | Install Fate via PIP |
| `Test.Default` | Test solution with default parameters |
| `Test.Config` | Test solution with configured parameters |
