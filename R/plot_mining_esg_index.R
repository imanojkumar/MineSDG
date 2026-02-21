#' Plot Mining ESG Composite Index
#'
#' Creates a ranked horizontal bar chart of composite ESG risk.
#'
#' @param index_data data.table returned by generate_mining_esg_index()
#'
#' @return ggplot object
#'
#' @importFrom stats reorder
#'
#' @export
plot_mining_esg_index <- function(index_data) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' required.", call. = FALSE)
  }

  if (!inherits(index_data, "data.table")) {
    stop("Input must be output of generate_mining_esg_index().",
         call. = FALSE)
  }

  ggplot2::ggplot(index_data,
                  ggplot2::aes(
                    x = stats::reorder(country, composite_score),
                    y = composite_score,
                    fill = risk_category
                  )) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::labs(
      title = "Mining ESG Composite Risk Index",
      x = "Country",
      y = "Composite Risk Score"
    ) +
    ggplot2::theme_minimal()
}
