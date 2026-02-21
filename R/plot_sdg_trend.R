#' Plot SDG Indicator Trend
#'
#' Creates a publication-ready time-series plot for SDG indicator data.
#'
#' @param data A data.table returned by fetch_sdg_country_data().
#' @param indicator Optional indicator code to filter.
#' @param country Optional ISO3 country code to filter.
#'
#' @return A ggplot object.
#'
#' @export
plot_sdg_trend <- function(data,
                           indicator = NULL,
                           country = NULL) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required.", call. = FALSE)
  }

  if (!inherits(data, "data.table")) {
    stop("`data` must be a data.table.", call. = FALSE)
  }

  dt <- data.table::copy(data)

  if (!is.null(indicator)) {
    dt <- dt[indicator == indicator]
  }

  if (!is.null(country)) {
    dt <- dt[country == country]
  }

  if (nrow(dt) == 0) {
    stop("No data available for selected filters.",
         call. = FALSE)
  }

  p <- ggplot2::ggplot(dt,
                       ggplot2::aes(x = year,
                                    y = value,
                                    color = country,
                                    group = country)) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::geom_point(size = 2) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::labs(
      title = paste0("SDG Indicator Trend: ",
                     unique(dt$indicator)),
      x = "Year",
      y = "Value",
      color = "Country"
    )

  return(p)
}
