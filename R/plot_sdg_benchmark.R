#' Plot SDG Benchmark Comparison
#'
#' Creates a benchmark comparison bar chart.
#'
#' @param benchmark_data Output from benchmark_sdg_performance().
#'
#' @return A ggplot object.
#'
#' @export
plot_sdg_benchmark <- function(benchmark_data) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required.", call. = FALSE)
  }

  if (!inherits(benchmark_data, "data.table")) {
    stop("Input must be output from benchmark_sdg_performance().",
         call. = FALSE)
  }

  p <- ggplot2::ggplot(
    benchmark_data,
    ggplot2::aes(
      x = stats::reorder(country, value),
      y = value,
      fill = performance_category
    )
  ) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::labs(
      title = "SDG Benchmark Performance",
      x = "Country",
      y = "Indicator Value",
      fill = "Performance Category"
    )

  return(p)
}
