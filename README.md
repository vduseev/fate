# FATE

Fast Algorithm Testing Environment

`fate` executes given algorithm against a set of test cases consisting of input/output text file pairs. 

It determines whether the algorithm was correct and reports execution times and memory footprints. To do that with a predictable precision it uses `docker` to run executables in an isolated environment locally or in cloud. In case of a test case failure it prints the `diff` between the output of an algorithm and the desired output allowing for a line-by-line investigation of a failed alrogirhm.

To further aid the user it starts up a debugger for a step-by-step execution of an algorithm against a given test case.

Fate is designed with [HackerRank](https://www.hackerrank.com) in mind.

## Requirements

### Business requirements

### Functional requirements

- [ ] `FR-1` Run an executable file that contains an algorithmic solution to a given problem. Feed given input files to the executable and verify the outputs against the corresponding ouput files.
- [ ] `FR-2` Run the executable in an isolated container.
- [ ] `FR-3` Run the isolated container in the cloud with a predictable perfomance.
- [ ] `FR-4` Measure execution time.
- [ ] `FR-5` Measure memory usage.
- [ ] `FR-6` Calculate bettter measures using a multitude of statistical methods.
- [ ] `FR-7` Compile the source code using predefined docker images for each language.
- [ ] `FR-8` Debug solutions during test runs.
- [ ] `FR-9` Run executables asynchronously being able to stop/pause them at any moment.
- [ ] `FR-10` Send the source code to HackerRank and get back the results.
- [ ] `FR-11` Test a single solution against all input/output pairs.
- [ ] `FR-12` Test a single solution against a single input/output pair.
- [ ] `FR-13` Test all solutions in all the languages for the given problem.
- [ ] `FR-14` Test all solutions in the repository.

### User interface

- [ ] `UI-1` `fate` is a systemwide command line tool.
- [ ] `UI-2` Installed via Homebrew on MacOS and Apt on Debian systems.
- [ ] `UI-3` Configuration files in the directory to control the behaviour of `fate`.

### Inputs and outputs

#### Inputs

- [ ] `IO-1` Current directory is cosidered to be the current execution context.
- [ ] `IO-2` Expected directory layout to support `fate`:

  ```shell
  repository-with-solutions/    # your repository, where all solutions are contained
    algorithms/                 # subsection of solutions to specific domain
      solve-me-first/           # single problem
        input/                  # directory with input files
          input00.txt           # input file of pair "00"
          input01.txt
          ...
        output/                 # directory with output files
          output00.txt          # output file matching the "00" input file
          output01.txt
          ...
        python3/                # solutions in specific language (see language naming below)
          solution01.py         # one of the solutions
          mega-test-case.in     # a custom test case input test file thrown in during development
          meta.out              # a corresponding test case output file for quick test
          bottom-up/            # directory with another solution
            bottom-up.py        # another solution
          ...
        java8/
        cpp/
        ...
    data-structures/
    sql/
    ...
  ```

  Another layout

  ```shell
  testing/
    solve.sh
    tc0.in
    tc0.out
    input-basic.txt
    output-basic.txt
    input/
      input00.txt
      input34.txt
    output/
      output00.txt
      output34.txt
  ```

- [ ] `IO-3` Input/output files are searched in the following order:
  - [ ] `IO-3.1` Matching pairs of files in the current directory with a naming convention being `input*.txt` and `output*.txt`.
  - [ ] `IO-3.2` Matching pairs of files with the same pattern but being placed in the `./input/` and `./output/` subdirectories of the current directory.
  - [ ] `IO-3.3` Same two attempts but in the parent directory `./..`.
  - [ ] `IO-3.4` Again, same two attempts but in the grandparent directory `./../..`
  - This means that `fate` traverses 3 levels of directories: the current directory and into two levels above the current directory.
  - Higher level directories are traversed if the current directory had no matching pairs of input/output files.
  - [ ] `IO-4` Read input and output interactively from stdin.
- [ ] `IO-5` The executable solution is searched in the following order:
  - [ ] `IO-5.1` `fate [path]` specified as the absolute/relative path in the first positional argument during invokation
  - [ ] `IO-5.2` First executable file in the current directory `./`.
  - [ ] `IO-5.3` First executable in any of the subdirectories `./*/`.
  - [ ] `IO-5.4` First executable in any of the sub-subdirectories `./*/*/`
- [ ] `IO-6` Language codes for solution languages are as following:

  | Code     | Language                  |
  | -------- | ------------------------- |
  | bash     | Bash ~>4                  |
  | c        | C98                       |
  | csharp   | C#, .Net 5.0              |
  | cpp      | C++98                     |
  | cpp14    | C++14                     |
  | go       | Go                        |
  | java7    | Java 7                    |
  | java8    | Java 8                    |
  | js       | JavaScript (Node.js)      |
  | pypy2    | PyPy 2                    |
  | pypy3    | PyPy 3                    |
  | python2  | Python 2.7.15             |
  | python3  | Python 3.8                |
  | postgres | PostgreSQL 11.0           |
  | oracle   | Oracle 11.0               |

#### Outputs

##### Exceptions and error handling

- [ ] `ERR-1` If no mathing input/output pairs are found then:
  - [ ] `Matching input/output files are not found` message is printed to stderr.
  - [ ] `fate` exits with code `1`.
- [ ] `ERR-2` If no executable is found then:
  - [ ] `Executable solution not found` message is printed to stderr.
  - [ ] `fate` exits with code `2`.
- [ ] `ERR-3` If executable does not exist:
  - [ ] `Executable <path> does not exist` message is printed to stderr.
  - [ ] `fate` exits with code `3`.
- [ ] `ERR-4` If specified executable file has no execution rights:
  - [ ] `File <path> cannot be executed` message is printed to stderr.
  - [ ] `fate` exits with code `4`.

##### Warnings

- [ ] `WAR-1` If input/output file size is larger than 1GiB:
  - [ ] `File <path> is larger than 1GiB` message is printed to stdout.
