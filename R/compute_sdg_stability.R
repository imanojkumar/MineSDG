#' Compute SDG Stability Metrics
#'
#' Calculates variability and stability statistics for SDG indicator data.
#'
#' @param data A data.table returned by fetch_sdg_country_data().
#' @param group_by Character vector of grouping columns.
#'
#' @return A data.table containing stability metrics.
#'
#' @examples
#' \dontrun{
#' dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
#' compute_sdg_stability(dt)
#' }
#'
#' @export
compute_sdg_stability <- function(data,
                                  group_by = c("indicator", "country")) {

  if (!inherits(data, "data.table")) {
    stop("`data` must be a data.table.", call. = FALSE)
  }

  required_cols <- c("indicator", "country", "value")

  if (!all(required_cols %in% names(data))) {
    stop("Input data does not appear to be valid SDG data.",
         call. = FALSE)
  }

  dt <- data.table::copy(data)

  result <- dt[!is.na(value),
               .(
                 observations = .N,
                 mean_value = mean(value, na.rm = TRUE),
                 sd_value = stats::sd(value, na.rm = TRUE),
                 coefficient_of_variation =
                   stats::sd(value, na.rm = TRUE) /
                   mean(value, na.rm = TRUE)
               ),
               by = group_by]

  result[, volatility_index :=
           round(coefficient_of_variation * 100, 2)]

  result[, stability_category :=
           ifelse(volatility_index < 5, "Highly Stable",
                  ifelse(volatility_index < 15, "Moderately Stable",
                         "Volatile"))]

  return(result[])
}
