#' Generate Composite Mining ESG Index
#'
#' Builds a composite Mining ESG Risk Index by aggregating
#' multiple SDG indicators using flexible weighting schemes.
#'
#' @param data data.table returned by fetch_sdg_country_data().
#' @param indicators Character vector of SDG indicator codes.
#' @param weighting_method Character. One of:
#'   "equal", "domain_weighted", "custom".
#' @param custom_weights Named numeric vector of weights
#'   (required if weighting_method = "custom").
#'
#' @return A data.table containing:
#' \describe{
#'   \item{country}{Country ISO3}
#'   \item{composite_score}{Aggregated ESG risk score}
#'   \item{risk_category}{Overall risk classification}
#' }
#'
#' @export
generate_mining_esg_index <- function(data,
                                      indicators,
                                      weighting_method = "equal",
                                      custom_weights = NULL) {

  if (!inherits(data, "data.table")) {
    stop("`data` must be a data.table returned by fetch_sdg_country_data().",
         call. = FALSE)
  }

  if (!is.character(indicators) || length(indicators) < 1) {
    stop("`indicators` must be a character vector.",
         call. = FALSE)
  }

  valid_methods <- c("equal", "domain_weighted", "custom")

  if (!weighting_method %in% valid_methods) {
    stop("Invalid weighting_method. Choose from: equal, domain_weighted, custom.",
         call. = FALSE)
  }

  # Filter data
  dt <- data[data$indicator %in% indicators, ]

  if (nrow(dt) == 0) {
    stop("No matching indicators found in dataset.",
         call. = FALSE)
  }

  countries <- unique(dt$country)

  results_list <- list()

  for (ctry in countries) {

    dt_country <- dt[dt$country == ctry, ]

    indicator_scores <- numeric()
    weights <- numeric()

    for (ind in indicators) {

      dt_ind <- dt_country[dt_country$indicator == ind, ]

      if (nrow(dt_ind) == 0) next

      risk_profile <- generate_mining_risk_profile(
        data = dt_ind,
        indicator = ind
      )

      indicator_scores[ind] <- risk_profile$risk_score

      # Weight calculation
      if (weighting_method == "equal") {

        weights[ind] <- 1

      } else if (weighting_method == "domain_weighted") {

        domain_info <- map_sdg_to_mining_domain(ind)
        weights[ind] <- domain_info$relevance_score

      } else if (weighting_method == "custom") {

        if (is.null(custom_weights)) {
          stop("custom_weights must be provided when weighting_method = 'custom'.",
               call. = FALSE)
        }

        if (!all(indicators %in% names(custom_weights))) {
          stop("custom_weights must be a named vector matching indicators.",
               call. = FALSE)
        }

        weights[ind] <- custom_weights[ind]
      }
    }

    if (length(indicator_scores) == 0) next

    weights <- weights[names(indicator_scores)]

    normalized_weights <- weights / sum(weights)

    composite_score <- round(
      sum(indicator_scores * normalized_weights),
      2
    )

    risk_category <- dplyr::case_when(
      composite_score <= 1 ~ "Low Risk",
      composite_score <= 2.5 ~ "Moderate Risk",
      composite_score <= 4 ~ "High Risk",
      TRUE ~ "Critical Risk"
    )

    results_list[[ctry]] <- data.table::data.table(
      country = ctry,
      composite_score = composite_score,
      risk_category = risk_category
    )
  }

  final_result <- data.table::rbindlist(results_list)

  # Ranking (lower score = lower risk = better)
  final_result[, rank :=
                 data.table::frank(composite_score,
                                   ties.method = "average")]

  final_result[, percentile :=
                 round(100 * (1 - (rank - 1) / .N), 2)]

  data.table::setorder(final_result, composite_score)

  return(final_result[])
}
