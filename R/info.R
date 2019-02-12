
#' Is this a Windows machine?
#'
#' Returns \code{TRUE} if the code is being run on Windows.
#'
#' @export
is_win <- function() .Platform$OS.type == "windows"

#' Information
#'
#' Reports information on the current setup.
#'
#' @export
info <- function() {

  message(cli::rule("Basic info"))
  message(glue::glue("fs version: {packageVersion('fs')}"))
  message(glue::glue("R version: {R.version.string}"))
  session <- utils::sessionInfo()
  message(glue::glue("platform: {session$platform}"))
  message(glue::glue("locale: {session$locale}"))

  message(cli::rule("Directories"))
  message(glue::glue("current: {fs::path_wd()}"))
  message(glue::glue("home: {fs::path_home()}"))
  message(glue::glue("home (R): {fs::path_home_r()}"))
  message(glue::glue("R installation: {R.home()}"))
  message(glue::glue("Temporary: {fs::path_temp()}"))

  if (is_win()) {
    message(cli::rule("Windows info"))
    message(glue::glue('HOMEDRIVE: {Sys.getenv("HOMEDRIVE")}'))
    message(glue::glue('HOMEPATH: {Sys.getenv("HOMEPATH")}'))
    message(glue::glue('USERPROFILE: {Sys.getenv("USERPROFILE")}'))
  }

  return(invisible(NULL))
}
