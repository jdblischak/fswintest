context("test-fs")

library(fs)

describe("dir_exists", {

  it("works for paths with trailing forward slash", {
    d_forward <- paste0(file_temp(), "/")
    expect_false(dir_exists(d_forward))
    dir_create(d_forward)
    expect_true(dir_exists(d_forward))
    expect_true(dir_exists(path(d_forward)))
  })

  it("works for paths with trailing back slash", {
    d_back <- paste0(file_temp(), "\\")
    expect_false(dir_exists(d_back))
    dir_create(d_back)
    expect_true(dir_exists(d_back))
    expect_true(dir_exists(path(d_back)))
  })

})

describe("path_rel", {

  it("works for relative paths that connect via the Windows drive", {
    d1 <- "D:/test1/d1"
    d2 <- "D:/test2/d2"
    expect_equal(path_rel(d2, start = d1), "../../test2/d2")
  })

  it("works for relative paths with case differences that connect via the Windows drive", {
    d1 <- "D:/test1/d1"
    d2 <- "d:/test2/d2"
    expect_equal(path_rel(d2, start = d1), "../../test2/d2")
  })

  it("can be reversed by path_abs", {
    f <- file_temp()
    expect_equal(path_abs(path_rel(f)), f)
    file_create(f)
    expect_true(file_exists(f))
    expect_true(file_exists(path_abs(path_rel(f))))
  })

})

describe("path_wd", {

  it("returns the same as getwd", {
    expect_equal(path_wd(), getwd())
  })

  it("returns the Windows drive the same case as file_temp", {
    if (!is_win()) skip("Only relevant on Windows")

    drive_temp <- path_split(path_temp())[[1]][1]
    drive_wd <- path_split(path_wd())[[1]][1]
    expect_identical(drive_temp, drive_wd)
    expect_identical(toupper(drive_temp), toupper(drive_wd))
  })

})
