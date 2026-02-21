#' Summarize SDG Indicator Data
#'
#' Generates descriptive statistics and data quality diagnostics
#' for SDG indicator datasets retrieved via \code{fetch_sdg_country_data()}.
#'
#' Supports optional grouping by indicator, country, year, or combinations.
#'
#' @param data A data.table returned by \code{fetch_sdg_country_data()}.
#' @param group_by Character vector of column names to group by.
#'   Allowed values: "indicator", "country", "year".
#'   Default NULL (overall summary).
#' @param na.rm Logical. Remove NA values when computing statistics.
#'   Default TRUE.
#'
#' @return A data.table containing summary statistics.
#'
#' @examples
#' \dontrun{
#' dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
#' summarize_sdg_data(dt)
#' summarize_sdg_data(dt, group_by = "year")
#' summarize_sdg_data(dt, group_by = c("indicator", "country"))
#' }
#'
#' @export
summarize_sdg_data <- function(data,
                               group_by = NULL,
                               na.rm = TRUE) {

  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Package 'data.table' is required.", call. = FALSE)
  }

  if (!inherits(data, "data.table")) {
    stop("`data` must be a data.table object.", call. = FALSE)
  }

  required_cols <- c("indicator", "country", "year", "value")

  if (!all(required_cols %in% names(data))) {
    stop("Input data does not appear to be valid SDG data.",
         call. = FALSE)
  }

  allowed_groups <- c("indicator", "country", "year")

  if (!is.null(group_by)) {
    if (!all(group_by %in% allowed_groups)) {
      stop(
        paste0("group_by must be one of: ",
               paste(allowed_groups, collapse = ", ")),
        call. = FALSE
      )
    }
  }

  dt <- data.table::copy(data)

  summary_expr <- list(
    observations = .N,
    countries = data.table::uniqueN(country),
    years = data.table::uniqueN(year),
    min_year = min(year, na.rm = TRUE),
    max_year = max(year, na.rm = TRUE),
    mean = mean(value, na.rm = na.rm),
    median = stats::median(value, na.rm = na.rm),
    min = min(value, na.rm = na.rm),
    max = max(value, na.rm = na.rm),
    sd = stats::sd(value, na.rm = na.rm),
    cv = ifelse(
      mean(value, na.rm = na.rm) == 0,
      NA_real_,
      stats::sd(value, na.rm = na.rm) /
        mean(value, na.rm = na.rm)
    ),
    missing_pct = round(
      100 * sum(is.na(value)) / .N, 2
    )
  )

  if (is.null(group_by)) {

    result <- dt[, summary_expr]

  } else {

    result <- dt[, summary_expr, by = group_by]
  }

  return(result[])
}
