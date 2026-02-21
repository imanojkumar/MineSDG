#' Plot SDG Volatility
#'
#' Visualizes SDG indicator variability across countries.
#'
#' @param stability_data Output from compute_sdg_stability().
#'
#' @return A ggplot object.
#'
#' @export
plot_sdg_volatility <- function(stability_data) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required.", call. = FALSE)
  }

  if (!inherits(stability_data, "data.table")) {
    stop("Input must be output from compute_sdg_stability().",
         call. = FALSE)
  }

  p <- ggplot2::ggplot(
    stability_data,
    ggplot2::aes(
      x = stats::reorder(country, volatility_index),
      y = volatility_index,
      fill = stability_category
    )
  ) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::labs(
      title = "SDG Volatility Index",
      x = "Country",
      y = "Volatility Index (%)",
      fill = "Stability Category"
    )

  return(p)
}
