#' Plot SDG Convergence
#'
#' Creates a convergence scatter plot showing initial value vs growth rate.
#'
#' @param data A data.table returned by fetch_sdg_country_data().
#' @param base_year Optional base year. If NULL, earliest year is used.
#' @param final_year Optional final year. If NULL, latest year is used.
#'
#' @return A ggplot object.
#'
#' @export
plot_sdg_convergence <- function(data,
                                 base_year = NULL,
                                 final_year = NULL) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required.", call. = FALSE)
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

  if (is.null(base_year)) {
    base_year <- min(dt$year, na.rm = TRUE)
  }

  if (is.null(final_year)) {
    final_year <- max(dt$year, na.rm = TRUE)
  }

  base_dt <- dt[year == base_year]
  final_dt <- dt[year == final_year]

  merged <- merge(base_dt,
                  final_dt,
                  by = c("indicator", "country"),
                  suffixes = c("_base", "_final"))

  merged[, growth_rate :=
           (value_final - value_base) /
           value_base]

  p <- ggplot2::ggplot(
    merged,
    ggplot2::aes(
      x = value_base,
      y = growth_rate
    )
  ) +
    ggplot2::geom_point(size = 3) +
    ggplot2::geom_smooth(method = "lm",
                         se = FALSE,
                         linewidth = 1) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::labs(
      title = "SDG Convergence Analysis",
      x = paste0("Initial Value (", base_year, ")"),
      y = "Growth Rate"
    )

  return(p)
}
