#' Validate SDG Indicator Code
#'
#' Checks whether a provided SDG indicator code exists
#' in the official UN SDG indicator database.
#'
#' Optionally verifies consistency between indicator and goal.
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
    if (!is.numeric(goal) || goal < 1 || goal > 17) {
      stop("`goal` must be numeric between 1 and 17.", call. = FALSE)
    }
  }

  # -----------------------------
  # Fetch metadata from UN API
  # -----------------------------
  base_url <- "https://unstats.un.org/SDGAPI/v1/sdg/Indicator/List"

  response <- tryCatch({
    httr2::request(base_url) |>
      httr2::req_perform()
  }, error = function(e) {
    stop(
      paste0(
        "Unable to retrieve SDG indicator metadata.\n",
        "Check internet connection or UN API availability.\n\n",
        "Technical message:\n", e$message
      ),
      call. = FALSE
    )
  })

  parsed <- httr2::resp_body_json(response)

  if (!is.list(parsed)) {
    stop("Unexpected API response structure.", call. = FALSE)
  }

  # -----------------------------
  # Locate the indicator entry
  # -----------------------------
  indicator_entry <- NULL

  for (item in parsed) {
    if (!is.null(item$code) && item$code == indicator) {
      indicator_entry <- item
      break
    }
  }

  if (is.null(indicator_entry)) {
    stop(
      paste0(
        "Invalid SDG indicator: ", indicator, "\n\n",
        "Please verify indicator code from:\n",
        "https://unstats.un.org/sdgs/indicators/database/"
      ),
      call. = FALSE
    )
  }

  # -----------------------------
  # Optional goal consistency check
  # -----------------------------
  if (!is.null(goal)) {

    indicator_goal <- as.numeric(indicator_entry$goal)

    if (indicator_goal != as.numeric(goal)) {
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
