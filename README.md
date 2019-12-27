# FATE

Fast Algorithm Testing Environment

## Requirements

### Functional requirements

- [ ] Run an executable file that contains an algorithmic solution to a given problem. Feed given input files to the executable and verify the outputs against the corresponding ouput files.
- [ ] Run the executable in an isolated container.
- [ ] Run the isolated container in the cloud with a predictable perfomance.
- [ ] Measure execution time.
- [ ] Measure memory usage.
- [ ] Calculate bettter measures using a multitude of statistical methods.
- [ ] Compile the source code using predefined docker images for each language.
- [ ] Debug solutions during test runs.
- [ ] Run executables asynchronously being able to stop/pause them at any moment.
- [ ] Send the source code to HackerRank and get back the results.
- [ ] Test a single solution against all input/output pairs.
- [ ] Test a single solution against a single input/output pair.
- [ ] Test all solutions in all the languages for the given problem.
- [ ] Test all solutions in the repository.

### User interface

- [ ] `fate` is a systemwide command line tool.
- [ ] Installed via Homebrew on MacOS and Apt on Debian systems.
- [ ] Configuration files in the directory to control the behaviour of `fate`.

### Inputs and outputs

#### Inputs

- [ ] Current directory is cosidered to be the current execution context.
- [ ] Expected directory layout to support `fate`:

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

- [ ] Input/output files are searched in the following order:
  - [ ] Matching pairs of files in the current directory with a naming convention being `input*.txt` and `output*.txt`.
  - [ ] Matching pairs of files with the same pattern but being placed in the `./input/` and `./output/` subdirectories of the current directory.
  - [ ] Same two attempts but in the parent directory `./..`.
  - [ ] Again, same two attempts but in the grandparent directory `./../..`
  - This means that `fate` traverses 3 levels of directories: the current directory and into two levels above the current directory.
  - Higher level directories are traversed if the current directory had no matching pairs of input/output files.
  - [ ] Read input and output interactively from stdin.
- [ ] The executable solution is searched in the following order:
  - [ ] `fate [path]` specified as the absolute/relative path in the first positional argument during invokation
  - [ ] First executable file in the current directory `./`.
  - [ ] First executable in any of the subdirectories `./*/`.
  - [ ] First executable in any of the sub-subdirectories `./*/*/`
- [ ] Language codes for solution languages are as following:

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

- [ ] If no mathing input/output pairs are found then:
  - [ ] `Matching input/output files are not found` message is printed to stderr.
  - [ ] `fate` exits with code `27`.
- [ ] If no executable is found then:
  - [ ] `Executable solution not found` message is printed to stderr.
  - [ ] `fate` exits with code `28`.
- [ ] If executable does not exist:
  - [ ] `Executable <path> does not exist` message is printed to stderr.
  - [ ] `fate` exits with code `29`.
- [ ] If specified executable file has no execution rights:
  - [ ] `File <path> cannot be executed` message is printed to stderr.
  - [ ] `fate` exits with code `30`.

##### Warnings

- [ ] If input/output file size is larger than 1GiB:
  - [ ] `File <path> is larger than 1GiB` message is printed to stdout.
