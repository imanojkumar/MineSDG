#' Analyze SDG Indicator Trend
#'
#' Computes trend metrics for SDG indicator data including
#' absolute change, percentage change, CAGR, and linear trend slope.
#'
#' Supports grouping by indicator, country, or combinations.
#'
#' @param data A data.table returned by fetch_sdg_country_data().
#' @param group_by Character vector of grouping columns.
#'   Default c("indicator", "country").
#' @param min_points Minimum number of time points required to compute trend.
#'   Default 3.
#'
#' @return A data.table containing trend statistics.
#'
#' @examples
#' \dontrun{
#' dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
#' analyze_sdg_trend(dt)
#' }
#'
#' @export
analyze_sdg_trend <- function(data,
                              group_by = c("indicator", "country"),
                              min_points = 3) {

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

  dt <- data.table::copy(data)

  if (!all(group_by %in% names(dt))) {
    stop("Invalid grouping columns provided.",
         call. = FALSE)
  }

  result <- dt[!is.na(value)][
    order(year),
    {

      if (.N < min_points) {
        list(
          observations = .N,
          start_year = NA_integer_,
          end_year = NA_integer_,
          start_value = NA_real_,
          end_value = NA_real_,
          absolute_change = NA_real_,
          percent_change = NA_real_,
          cagr = NA_real_,
          slope = NA_real_,
          trend_direction = "Insufficient data"
        )
      } else {

        start_year <- year[1]
        end_year <- year[.N]

        start_value <- value[1]
        end_value <- value[.N]

        absolute_change <- end_value - start_value

        percent_change <- if (start_value == 0) {
          NA_real_
        } else {
          100 * absolute_change / start_value
        }

        years_diff <- end_year - start_year

        cagr <- if (start_value <= 0 || years_diff <= 0) {
          NA_real_
        } else {
          ( (end_value / start_value)^(1 / years_diff) - 1 ) * 100
        }

        # Linear regression slope
        slope <- tryCatch({
          stats::coef(stats::lm(value ~ year))[2]
        }, error = function(e) NA_real_)

        trend_direction <- if (is.na(slope)) {
          "Undetermined"
        } else if (slope > 0) {
          "Increasing"
        } else if (slope < 0) {
          "Decreasing"
        } else {
          "Stable"
        }

        list(
          observations = .N,
          start_year = start_year,
          end_year = end_year,
          start_value = start_value,
          end_value = end_value,
          absolute_change = absolute_change,
          percent_change = percent_change,
          cagr = cagr,
          slope = slope,
          trend_direction = trend_direction
        )
      }

    },
    by = group_by
  ]

  return(result[])
}
