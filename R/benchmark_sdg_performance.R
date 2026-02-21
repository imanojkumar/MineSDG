#' Benchmark SDG Performance
#'
#' Compares SDG indicator performance against a benchmark
#' (global mean or user-supplied dataset).
#'
#' @param data A data.table returned by fetch_sdg_country_data().
#' @param benchmark_data Optional data.table with columns:
#'   indicator, year, value.
#'   If NULL, benchmark is computed as mean of provided data.
#' @param year Optional numeric year. If NULL, most recent year is used.
#' @param higher_is_better Logical. TRUE if higher values indicate
#'   better performance. Default TRUE.
#'
#' @return A data.table with benchmark comparison statistics.
#'
#' @examples
#' \dontrun{
#' dt <- fetch_sdg_country_data(goal = 15)
#' benchmark_sdg_performance(dt)
#' }
#'
#' @export
benchmark_sdg_performance <- function(data,
                                      benchmark_data = NULL,
                                      year = NULL,
                                      higher_is_better = TRUE) {

  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Package 'data.table' is required.", call. = FALSE)
  }

  if (!inherits(data, "data.table")) {
    stop("`data` must be a data.table.", call. = FALSE)
  }

  required_cols <- c("indicator", "country", "year", "value")

  if (!all(required_cols %in% names(data))) {
    stop("Input data does not appear to be valid SDG data.",
         call. = FALSE)
  }

  dt <- data.table::copy(data)

  # Select year
  if (is.null(year)) {
    year <- max(dt$year, na.rm = TRUE)
  }

  dt <- dt[year == year & !is.na(value)]

  if (nrow(dt) == 0) {
    stop("No data available for selected year.", call. = FALSE)
  }

  # Prepare benchmark
  if (is.null(benchmark_data)) {

    benchmark_dt <- dt[, .(
      benchmark_value = mean(value, na.rm = TRUE)
    ), by = .(indicator)]

  } else {

    if (!inherits(benchmark_data, "data.table")) {
      stop("`benchmark_data` must be a data.table.",
           call. = FALSE)
    }

    if (!all(c("indicator", "year", "value") %in% names(benchmark_data))) {
      stop("Benchmark dataset must contain indicator, year, value columns.",
           call. = FALSE)
    }

    benchmark_dt <- benchmark_data[
      year == year,
      .(indicator, benchmark_value = value)
    ]
  }

  # Merge benchmark
  result <- merge(
    dt,
    benchmark_dt,
    by = "indicator",
    all.x = TRUE
  )

  if (any(is.na(result$benchmark_value))) {
    warning("Some indicators missing benchmark values.",
            call. = FALSE)
  }

  # Compute statistics
  result[, deviation := value - benchmark_value]

  result[, percent_gap :=
           ifelse(benchmark_value == 0,
                  NA_real_,
                  100 * deviation / benchmark_value)]

  # Z-score per indicator
  result[, z_score :=
           (value - mean(value, na.rm = TRUE)) /
           stats::sd(value, na.rm = TRUE),
         by = indicator]

  # Ranking
  if (higher_is_better) {
    result[, rank := data.table::frank(-value,
                                       ties.method = "average"),
           by = indicator]
  } else {
    result[, rank := data.table::frank(value,
                                       ties.method = "average"),
           by = indicator]
  }

  # Performance category
  result[, performance_category :=
           ifelse(z_score >= 1, "Strong",
                  ifelse(z_score <= -1, "Weak",
                         "Moderate"))]

  return(result[])
}
