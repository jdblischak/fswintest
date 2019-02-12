# fswintest

[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/jdblischak/fswintest?branch=master&svg=true)](https://ci.appveyor.com/project/jdblischak/fswintest)

Tests the behavior of the [fs][] package on Windows machines, particularly on
[winbuilder][].

[fs]: https://cran.r-project.org/package=fs
[winbuilder]: https://win-builder.r-project.org/

## winbuilder results

Below are the tests results (`examples_and_tests/tests_x64/testthat.Rout.fail`):

```
R version 3.5.2 (2018-12-20) -- "Eggshell Igloo"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> library(testthat)
> library(fswintest)
> 
> test_check("fswintest")
-- 1. Failure: path_rel: works for relative paths with case differences that con
path_rel(d2, start = d1) not equal to "../../test2/d2".
1/1 mismatches
x[1]: "../../../d:/test2/d2"
y[1]: "../../test2/d2"

-- 2. Failure: path_rel: can be reversed by path_abs (@test-fs.R#39)  ----------
path_abs(path_rel(f)) not equal to `f`.
1/1 mismatches
x[1]: "d:/D:/temp/RtmpOEUaee/file186e43d3e368a"
y[1]: "D:/temp/RtmpOEUaee/file186e43d3e368a"

-- 3. Failure: path_rel: can be reversed by path_abs (@test-fs.R#42)  ----------
file_exists(path_abs(path_rel(f))) isn't true.

-- 4. Failure: path_wd: returns the Windows drive the same case as file_temp (@t
`drive_temp` not identical to `drive_wd`.
1/1 mismatches
x[1]: "D:"
y[1]: "d:"

== testthat results  ===========================================================
OK: 7 SKIPPED: 0 FAILED: 4
1. Failure: path_rel: works for relative paths with case differences that connect via the Windows drive (@test-fs.R#34) 
2. Failure: path_rel: can be reversed by path_abs (@test-fs.R#39) 
3. Failure: path_rel: can be reversed by path_abs (@test-fs.R#42) 
4. Failure: path_wd: returns the Windows drive the same case as file_temp (@test-fs.R#58) 

Error: testthat unit tests failed
Execution halted
```

There are two main issues:

1. `fs::dir_exists()` returns `FALSE` if the path to an existing directory ends
in a trailing `/` or `\\`. This pecularity appears to be limited to winbuilder.

1. `fs::path_wd()` returns the Windows drive in lower case (`d:/`) while
`fs::path_temp()` returns it in upper case (`D:/`). This isn't initially an
issue because Windows is a case-insensitive file system. However, the problem
arises when trying to do path manipulations like `fs::path_rel()`, which do not
take the case-insensitivity of the file system into account.

Potential solutions:

1. For `fs::dir_exists()`, strip any trailing slash by first passing it through
`fs::path()`. Change:
    ```
    res <- is_dir(path)
    ```
    to
    ```
    res <- is_dir(path(path))
    ```

1. For differences in the case of the Windows drive, I propose that the
definition of a tidy path (`fs::path_tidy()`) is expanded to include the
requirement that the Windows drive is always capitalized.
