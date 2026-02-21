#' List SDG Indicators and Descriptions
#'
#' Retrieves the official list of SDG indicators, including
#' indicator codes, descriptions, goal numbers, and tier classification.
#'
#' Uses internally cached metadata via `get_sdg_metadata()`.
#'
#' @param goal Numeric (1–17). Optional SDG goal number to filter indicators.
#'
#' @return A data.table containing:
#' \describe{
#'   \item{goal}{SDG goal number}
#'   \item{indicator}{Indicator code}
#'   \item{description}{Indicator description}
#'   \item{tier}{Tier classification}
#' }
#'
#' @examples
#' \dontrun{
#' list_sdg_indicators()
#' list_sdg_indicators(goal = 15)
#' }
#'
#' @export
list_sdg_indicators <- function(goal = NULL) {

  # -----------------------------
  # Input validation
  # -----------------------------
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
  dt <- get_sdg_metadata()

  # -----------------------------
  # Optional goal filtering
  # -----------------------------
  if (!is.null(goal)) {
    dt <- dt[goal == !!goal]
  }

  # -----------------------------
  # User-friendly message
  # -----------------------------
  if (!is.null(goal)) {
    message(
      "\nGoal ", goal, " Indicators\n",
      "--------------------------------"
    )
  } else {
    message(
      "\nAll SDG Indicators\n",
      "--------------------------------"
    )
  }

  return(dt[])
}
