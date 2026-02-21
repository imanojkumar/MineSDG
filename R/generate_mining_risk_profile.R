#' Generate Mining SDG Risk Profile
#'
#' Integrates SDG trend, stability, benchmarking,
#' and mining-sector relevance to produce a structured
#' ESG risk assessment.
#'
#' @param data data.table returned from fetch_sdg_country_data()
#' @param indicator Character. SDG indicator code.
#'
#' @return A structured list containing:
#' \describe{
#'   \item{indicator}{SDG indicator}
#'   \item{domain}{Mining domain}
#'   \item{risk_score}{Numeric weighted risk score}
#'   \item{risk_category}{Risk classification}
#'   \item{executive_summary}{Narrative explanation}
#' }
#'
#' @export
generate_mining_risk_profile <- function(data,
                                         indicator) {

  if (!inherits(data, "data.table")) {
    stop("`data` must be a data.table returned by fetch_sdg_country_data().",
         call. = FALSE)
  }

  validate_sdg_indicator(indicator)

  # Filter to selected indicator
  data_filtered <- data[data$indicator == indicator, ]

  if (nrow(data_filtered) == 0) {
    stop("No data found for selected indicator.",
         call. = FALSE)
  }

  # -----------------------------
  # Trend
  # -----------------------------
  trend_res <- analyze_sdg_trend(data_filtered)
  trend_direction <- trend_res$trend_direction

  trend_score <- switch(
    trend_direction,
    "Improving" = 0,
    "Stable" = 1,
    "Deteriorating" = 2,
    1
  )

  # -----------------------------
  # Stability
  # -----------------------------
  stability_res <- compute_sdg_stability(data_filtered)
  volatility <- stability_res$volatility_class

  stability_score <- switch(
    volatility,
    "Low" = 0,
    "Moderate" = 1,
    "High" = 2,
    1
  )

  # -----------------------------
  # Benchmark (Mean Comparison)
  # -----------------------------
  benchmark_res <- benchmark_sdg_performance(data_filtered)

  # Use most recent observation
  benchmark_res <- benchmark_res[1]

  gap <- benchmark_res$percent_gap

  benchmark_score <- ifelse(
    is.na(gap), 1,
    ifelse(abs(gap) < 5, 1,
           ifelse(gap > 0, 0, 2))
  )

  # -----------------------------
  # Domain Mapping
  # -----------------------------
  domain_res <- map_sdg_to_mining_domain(indicator = indicator)

  relevance_weight <- domain_res$relevance_score / 5

  # -----------------------------
  # Final Risk Calculation
  # -----------------------------
  base_risk <- trend_score + stability_score + benchmark_score

  weighted_risk <- round(base_risk * relevance_weight, 2)

  risk_category <- dplyr::case_when(
    weighted_risk <= 1 ~ "Low Risk",
    weighted_risk <= 2.5 ~ "Moderate Risk",
    weighted_risk <= 4 ~ "High Risk",
    TRUE ~ "Critical Risk"
  )

  executive_summary <- paste(
    "Indicator", indicator,
    "falls under the", domain_res$domain, "domain.",
    "Trend is", trend_direction,
    "with", volatility, "volatility.",
    "Benchmark deviation is", round(gap, 2), "%.",
    "Weighted ESG risk classified as:", risk_category, "."
  )

  output <- list(
    indicator = indicator,
    domain = domain_res$domain,
    risk_score = weighted_risk,
    risk_category = risk_category,
    executive_summary = executive_summary
  )

  class(output) <- "minesdg_risk_profile"

  return(output)
}
