# FATE

Fast Algorithm Testing Environment

`fate` executes given algorithm against a set of test cases consisting of input/output text file pairs.

It determines whether the algorithm was correct and reports execution times and memory footprints. To do that with a predictable precision it uses `docker` to run executables in an isolated environment locally or in cloud. In case of a test case failure it prints the `diff` between the output of an algorithm and the desired output allowing for a line-by-line investigation of a failed algorithm.

To further aid the user it starts up a debugger for a step-by-step execution of an algorithm against a given test case.

Fate is designed with [HackerRank](https://www.hackerrank.com) in mind.

## Installation

```shell
# Clone repository
git clone git@github.com:vduseev/fate.git
cd fate

# Install virtual environment and dependencies
poetry install

# Run command
poetry run fate test
```

## Usage

### `FR-11` Test a single solution against all discoverable test cases

```shell
# Specify executable and environment
fate run solution.py --env python3

# Specify executable only, environment is determined automatically
fate run solution.py

# Specify nothing, everything is determined automatically
fate run
```

### `FR-12` Test a single solution against a single test case

```shell
fate run solution.py -i input/input00.txt -o output/output00.txt
```

### Dependencies

* bash >=4.3
* Docker >= 1.25
