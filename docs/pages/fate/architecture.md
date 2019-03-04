---
title: "Architecture"
keywords: architecture
sidebar: fate_sidebar
permalink: architecture.html
summary: >-
  This page describes Fate's program architecture.
---
## Overview

Fate is implemented in Python 3 language and uses assert mechanics from {% include architecture/dependencies/pytest %} library. Its main purpose is to be installed as a command line program that can be called from any directory to test an executable solution against a given set of input and output files.

Fate has to parse arguments and config files. It also has to apply default values in case any of the required rules were not specified in arguments or configs.

Fate's main task is to run a given executable as a child process by providing it with input data and then comparing its output with the given output file.

Fate also measures the execution time using the most precise mechanism available in the standard Python 3 library. But this functionality is planned for `2018.Q2` release.

## Components

| Name | Purpose |
|-|-|
| {% include architecture/components/main %} | Initiates execution of the program. |
| `ArgumentParser` | Parses command line arguments |
| `ConfigParser` | Parses Fate's config files |
| `SubprocessRunner` | Runs an executable solution as a subprocess of Fate. |
| `TestExecutor` | Executes a single run of executable solution using `SubprocessRunner` and a single pair of input and output test data files.<br/>In `2018.Q2` release will be extended to measure execution time.<br/>In future releases will be extended to be capable of running tests in an isolated Docker environment. |
| {% include architecture/components/configuration_manager %} | Assembles a final running configuration out of command line arguments, config files, and default values.<br/>Responsible for searching of config files as well. |
| `Configuration` | A final configuration entity produced by `ConfigurationManager`.<br/>Implemented as a dictionary. |
| `TestManager` | Main test control facility that is responsible for running multiple tests with different input and output test data files. Relies on `TestConfiguration` |

## Component Dependency Graph

## Algorithm

1. `MainEntryPoint` creates an instance of the `ConfigurationManager` that collects configuration for the current run from all the places.
2. `MainEntryPoint` creates an instance of the `TestManager` and passes the instance of `ConfigurationManager` to its constructor.
3. `TestManager` forms full list of input/output test data pairs, then runs a loop through all the formed pairs. In each iteration a new instance of `TestExecutor` is created. The results of the test are collected and immediately compared using `py.test` library's `assert string1 = string2` operation. Results of comparison are published to the standard output immediately. If test has **failed**, then further execution is halted. However, if `ignore_test_fail` option is set to true, then `TestManager` will continue with remaining test pairs.



## Fate's Usage Algorithm

1. User runs `fate` in the directory
1. Fate reads arguments:

   1. If `1st` positional argument is present, then Fate will treat that string as a path to executable solution that has to be tested.

      * Note, that both relative and absolute paths are acceptable.
      * Usage examples: `fate solution.py`. Here Fate will execute the `solution.py` executable in the current directory.

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
