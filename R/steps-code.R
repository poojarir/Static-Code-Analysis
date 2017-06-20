RunCode <- R6Class(
  "RunCode", inherit = TicStep,

  public = list(
    initialize = function(call) {
      call <- substitute(call)
      private$call <- call
      private$seed <- 123
    },

    run = function() {
      set.seed(private$seed)
      eval(private$call, envir = .GlobalEnv)
    },

    prepare = function() {
      func_name <- private$call[[1]]
      if (is.call(func_name) && func_name[[1]] == quote(`::`)) {
        pkg_name <- as.character(func_name[[2]])
        verify_install(pkg_name)
      }
    }
  ),

  private = list(
    call = NULL,
    seed = NULL
  )
)

#' @export
step_run_code <- RunCode$new