#' Validate SDG Indicator Code
#'
#' Checks whether a provided SDG indicator code exists
#' in the official UN SDG indicator database.
#'
#' Optionally verifies consistency between indicator and goal.
#'
#' Uses internally cached metadata via `get_sdg_metadata()`.
#'
#' @param indicator Character. SDG indicator code (e.g., "15.3.1").
#' @param goal Numeric (1–17). Optional SDG goal number for consistency check.
#'
#' @return Logical TRUE if valid. Stops with error if invalid.
#'
#' @examples
#' \dontrun{
#' validate_sdg_indicator("15.3.1")
#' validate_sdg_indicator("15.3.1", goal = 15)
#' }
#'
#' @export
validate_sdg_indicator <- function(indicator, goal = NULL) {

  # -----------------------------
  # Basic input validation
  # -----------------------------
  if (is.null(indicator)) {
    stop("Indicator cannot be NULL.", call. = FALSE)
  }

  if (!is.character(indicator) || length(indicator) != 1) {
    stop("Indicator must be a single character string.", call. = FALSE)
  }

  if (!is.null(goal)) {
    if (!is.numeric(goal) || length(goal) != 1 ||
        goal < 1 || goal > 17) {
      stop("`goal` must be numeric between 1 and 17.",
           call. = FALSE)
    }
  }

  # -----------------------------
  # Retrieve cached metadata
  # -----------------------------
  metadata_dt <- get_sdg_metadata()

  # -----------------------------
  # Check indicator existence
  # -----------------------------
  indicator_entry <- metadata_dt[indicator == !!indicator]

  if (nrow(indicator_entry) == 0) {
    stop(
      paste0(
        "Invalid SDG indicator: ", indicator, "\n\n",
        "Use list_sdg_indicators() to explore valid indicators."
      ),
      call. = FALSE
    )
  }

  # -----------------------------
  # Optional goal consistency check
  # -----------------------------
  if (!is.null(goal)) {

    indicator_goal <- indicator_entry$goal[1]

    if (indicator_goal != goal) {
      stop(
        paste0(
          "Indicator ", indicator,
          " belongs to Goal ", indicator_goal,
          ", but goal = ", goal, " was provided.\n",
          "Please ensure goal and indicator are consistent."
        ),
        call. = FALSE
      )
    }
  }

  message(
    "Indicator ", indicator,
    " is valid",
    if (!is.null(goal)) paste0(" under Goal ", goal) else "",
    "."
  )

  return(TRUE)
}
