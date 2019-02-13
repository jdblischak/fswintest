# fswintest

[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/jdblischak/fswintest?branch=master&svg=true)](https://ci.appveyor.com/project/jdblischak/fswintest)

Tests the behavior of the [fs][] package on Windows machines, particularly on
[winbuilder][].

[fs]: https://cran.r-project.org/package=fs
[winbuilder]: https://win-builder.r-project.org/

## Issue and potential solution

`fs::path_wd()` returns the Windows drive in lower case (`d:/`) while
`fs::path_temp()` returns it in upper case (`D:/`). This isn't initially an
issue because Windows is a case-insensitive file system. However, the problem
arises when trying to do path manipulations like `fs::path_rel()`, which do not
take the case-insensitivity of the file system into account.

For differences in the case of the Windows drive, I propose that the definition
of a tidy path (`fs::path_tidy()`) is expanded to include the requirement that
the Windows drive is always capitalized.

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

-- 2. Failure: path_rel: can be reversed by path_abs (@test-fs.R#61)  ----------
path_abs(path_rel(f)) not equal to `f`.
1/1 mismatches
x[1]: "d:/D:/temp/RtmpI1pvmi/file11c0c3b7c1fa0"
y[1]: "D:/temp/RtmpI1pvmi/file11c0c3b7c1fa0"

-- 3. Failure: path_rel: can be reversed by path_abs (@test-fs.R#64)  ----------
file_exists(path_abs(path_rel(f))) isn't true.

-- 4. Failure: path_wd: returns the Windows drive the same case as file_temp (@t
`drive_temp` not identical to `drive_wd`.
1/1 mismatches
x[1]: "D:"
y[1]: "d:"

== testthat results  ===========================================================
OK: 16 SKIPPED: 0 FAILED: 4
1. Failure: path_rel: works for relative paths with case differences that connect via the Windows drive (@test-fs.R#56) 
2. Failure: path_rel: can be reversed by path_abs (@test-fs.R#61) 
3. Failure: path_rel: can be reversed by path_abs (@test-fs.R#64) 
4. Failure: path_wd: returns the Windows drive the same case as file_temp (@test-fs.R#80) 

Error: testthat unit tests failed
Execution halted
```

# winbuilder information

* i386

```
>  info()
-- Basic info ------------------------------------------------------------------
fs version: 1.2.6
R version: R version 3.5.2 (2018-12-20)
platform: i386-w64-mingw32/i386 (32-bit)
locale: LC_COLLATE=C;LC_CTYPE=German_Germany.1252;LC_MONETARY=C;LC_NUMERIC=C;LC_TIME=C
-- Directories -----------------------------------------------------------------
current: d:/RCompile/CRANguest/R-release/fswintest.Rcheck/examples_i386
home: C:/Users/CRAN
home (R): C:/Users/CRAN/Documents
R installation: D:/RCompile/recent/R-35~1.2
Temporary: D:/temp/RtmpUNkmGJ
-- Windows info ----------------------------------------------------------------
HOMEDRIVE: C:
HOMEPATH: \Users\CRAN
USERPROFILE: C:\Users\CRAN
-- C:/ -------------------------------------------------------------------------
Drive C:/ contains the following directories:
C:/$Recycle.Bin
C:/adsm.sys
C:/Boot
C:/bootmgr
C:/BOOTSECT.BAK
C:/cmdline
C:/ConEmu
C:/Config.Msi
C:/Documents and Settings
C:/Dokumente und Einstellungen
C:/EnergyPlusV8-8-0
C:/fit4NM
C:/GBM
C:/inetpub
C:/Intel
C:/Klausur.xps
C:/lib
C:/localsolver_4_0
C:/newRtools
C:/Octave
C:/OkiDriver
C:/pagefile.sys
C:/PerfLogs
C:/Program Files
C:/Program Files (x86)
C:/ProgramData
C:/Programme
C:/System Volume Information
C:/Temp
C:/Users
C:/Windows
-- D:/ -------------------------------------------------------------------------
Drive D:/ contains the following directories:
D:/$RECYCLE.BIN
D:/adaptec
D:/C.bat
D:/census.RData
D:/Compiler
D:/cranmails.tar.gz
D:/ESS7CH.sav
D:/Excel_Varianz.xls
D:/gretl-2017d-64.exe
D:/id_rsa.pub
D:/library-devel
D:/lilypond-2.18.2-1.mingw.exe
D:/msys
D:/murdoch
D:/output.tif
D:/packages.rds
D:/problems.RData
D:/R-devel.bat
D:/R-devel64.bat
D:/R-old.bat
D:/R-old64.bat
D:/R-release.bat
D:/R-release64.bat
D:/R32devel493
D:/RCompile
D:/SBML
D:/svn.bat
D:/System Volume Information
D:/temp
D:/temp.RData
D:/tmp
D:/updateAll.bat
D:/wild.R-project.org.2018.crt
-- E:/ -------------------------------------------------------------------------
Drive E:/ contains the following directories:
E:/$RECYCLE.BIN
E:/Archiv
E:/System Volume Information
```

* x64

```
>  info()
-- Basic info ------------------------------------------------------------------
fs version: 1.2.6
R version: R version 3.5.2 (2018-12-20)
platform: x86_64-w64-mingw32/x64 (64-bit)
locale: LC_COLLATE=C;LC_CTYPE=German_Germany.1252;LC_MONETARY=C;LC_NUMERIC=C;LC_TIME=C
-- Directories -----------------------------------------------------------------
current: d:/RCompile/CRANguest/R-release/fswintest.Rcheck/examples_x64
home: C:/Users/CRAN
home (R): C:/Users/CRAN/Documents
R installation: D:/RCompile/recent/R-35~1.2
Temporary: D:/temp/RtmpULQoxD
-- Windows info ----------------------------------------------------------------
HOMEDRIVE: C:
HOMEPATH: \Users\CRAN
USERPROFILE: C:\Users\CRAN
-- C:/ -------------------------------------------------------------------------
Drive C:/ contains the following directories:
C:/$Recycle.Bin
C:/adsm.sys
C:/Boot
C:/bootmgr
C:/BOOTSECT.BAK
C:/cmdline
C:/ConEmu
C:/Config.Msi
C:/Documents and Settings
C:/Dokumente und Einstellungen
C:/EnergyPlusV8-8-0
C:/fit4NM
C:/GBM
C:/inetpub
C:/Intel
C:/Klausur.xps
C:/lib
C:/localsolver_4_0
C:/newRtools
C:/Octave
C:/OkiDriver
C:/pagefile.sys
C:/PerfLogs
C:/Program Files
C:/Program Files (x86)
C:/ProgramData
C:/Programme
C:/System Volume Information
C:/Temp
C:/Users
C:/Windows
-- D:/ -------------------------------------------------------------------------
Drive D:/ contains the following directories:
D:/$RECYCLE.BIN
D:/adaptec
D:/C.bat
D:/census.RData
D:/Compiler
D:/cranmails.tar.gz
D:/ESS7CH.sav
D:/Excel_Varianz.xls
D:/gretl-2017d-64.exe
D:/id_rsa.pub
D:/library-devel
D:/lilypond-2.18.2-1.mingw.exe
D:/msys
D:/murdoch
D:/output.tif
D:/packages.rds
D:/problems.RData
D:/R-devel.bat
D:/R-devel64.bat
D:/R-old.bat
D:/R-old64.bat
D:/R-release.bat
D:/R-release64.bat
D:/R32devel493
D:/RCompile
D:/SBML
D:/svn.bat
D:/System Volume Information
D:/temp
D:/temp.RData
D:/tmp
D:/updateAll.bat
D:/wild.R-project.org.2018.crt
-- E:/ -------------------------------------------------------------------------
Drive E:/ contains the following directories:
E:/$RECYCLE.BIN
E:/Archiv
E:/System Volume Information
```
