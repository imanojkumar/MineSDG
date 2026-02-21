#' Generate Executive Summary for SDG Performance
#'
#' Creates an executive-ready narrative summary based on
#' SDG trend analysis and optional benchmark comparison.
#'
#' @param trend_data Output from analyze_sdg_trend().
#' @param benchmark_data Optional output from benchmark_sdg_performance().
#' @param digits Number of digits for rounding values. Default 2.
#'
#' @return Character vector containing executive summary text.
#'
#' @examples
#' \dontrun{
#' dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
#' trend <- analyze_sdg_trend(dt)
#' summary_text <- generate_sdg_executive_summary(trend)
#' cat(summary_text)
#' }
#'
#' @export
generate_sdg_executive_summary <- function(trend_data,
                                           benchmark_data = NULL,
                                           digits = 2) {

  if (!inherits(trend_data, "data.table")) {
    stop("`trend_data` must be a data.table from analyze_sdg_trend().",
         call. = FALSE)
  }

  summaries <- trend_data[, {

    direction <- trend_direction
    abs_change <- round(absolute_change, digits)
    pct_change <- round(percent_change, digits)
    cagr_val <- round(cagr, digits)

    trend_sentence <- paste0(
      "Indicator ", indicator,
      " for ", country,
      " shows a ", tolower(direction),
      " trend over the observed period. ",
      "The absolute change was ", abs_change,
      " (", pct_change, "%), ",
      "with a compound annual growth rate (CAGR) of ",
      cagr_val, "%."
    )

    performance_sentence <- ""

    if (!is.null(benchmark_data)) {

      bench_row <- benchmark_data[
        indicator == .BY$indicator &
          country == .BY$country
      ]

      if (nrow(bench_row) > 0) {

        gap <- round(bench_row$percent_gap[1], digits)
        category <- bench_row$performance_category[1]

        performance_sentence <- paste0(
          " Relative to benchmark, performance is classified as ",
          category,
          " with a deviation of ",
          gap, "%."
        )
      }
    }

    list(summary_text = paste0(trend_sentence,
                               performance_sentence))

  }, by = .(indicator, country)]

  return(summaries$summary_text)
}
