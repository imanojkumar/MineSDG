#' Calculate Water Use Efficiency (SDG 6.4)
#'
#' Computes water use efficiency and recycling rates in alignment with
#' Global Reporting Initiative (GRI 303) standards and SDG Target 6.4.
#'
#' The function calculates the "Recycling Rate" as:
#' \deqn{(recycled\_m3 / (withdrawal\_m3 + recycled\_m3)) * 100}
#'
#' And "Net Water Consumption" (GRI 303-5) as:
#' \deqn{withdrawal\_m3 - discharge\_m3}
#'
#' @param withdrawal_m3 Numeric. Total water withdrawn from all sources (in cubic meters).
#'   Must be a non-negative number.
#' @param discharge_m3 Numeric. Total water discharged to all destinations (in cubic meters).
#'   Must be a non-negative number.
#' @param recycled_m3 Numeric. Total water recycled or reused (in cubic meters).
#'   Must be a non-negative number.
#'
#' @return A named list containing:
#' \describe{
#'   \item{metric}{Character string. "SDG 6.4 - Water Efficiency"}
#'   \item{net_consumption_m3}{Numeric. Net water consumed (Withdrawal - Discharge).}
#'   \item{recycling_rate_percent}{Numeric. Percentage of total water use that is recycled, rounded to 2 decimal places.}
#' }
#'
#' @examples
#' # Standard mining operation example
#' calculate_water_efficiency(
#'   withdrawal_m3 = 50000,
#'   discharge_m3 = 10000,
#'   recycled_m3 = 20000
#' )
#'
#' # Zero discharge example (Closed loop)
#' calculate_water_efficiency(1000, 0, 500)
#'
#' # Edge case: No water used
#' calculate_water_efficiency(0, 0, 0)
#'
#' @export
calculate_water_efficiency <- function(withdrawal_m3,
                                       discharge_m3,
                                       recycled_m3) {

  # -------------------------------
  # Input validation
  # -------------------------------
  # Check withdrawal_m3
  if (!is.numeric(withdrawal_m3) || length(withdrawal_m3) != 1 || is.na(withdrawal_m3)) {
    stop("`withdrawal_m3` must be a single non-negative numeric value.", call. = FALSE)
  }
  if (withdrawal_m3 < 0) {
    stop("`withdrawal_m3` cannot be negative.", call. = FALSE)
  }

  # Check discharge_m3
  if (!is.numeric(discharge_m3) || length(discharge_m3) != 1 || is.na(discharge_m3)) {
    stop("`discharge_m3` must be a single non-negative numeric value.", call. = FALSE)
  }
  if (discharge_m3 < 0) {
    stop("`discharge_m3` cannot be negative.", call. = FALSE)
  }

  # Check recycled_m3
  if (!is.numeric(recycled_m3) || length(recycled_m3) != 1 || is.na(recycled_m3)) {
    stop("`recycled_m3` must be a single non-negative numeric value.", call. = FALSE)
  }
  if (recycled_m3 < 0) {
    stop("`recycled_m3` cannot be negative.", call. = FALSE)
  }

  # -------------------------------
  # Core calculation
  # -------------------------------

  # 1. Net Water Consumption (GRI 303-5)
  consumption <- withdrawal_m3 - discharge_m3

  # 2. Total Water Demand (Withdrawal + Recycled)
  total_demand <- withdrawal_m3 + recycled_m3

  # 3. Recycling Rate (Circular Economy Metric)
  # Edge case: avoid division by zero if total demand is 0
  if (total_demand == 0) {
    recycle_rate <- 0
  } else {
    recycle_rate <- (recycled_m3 / total_demand) * 100
  }

  # -------------------------------
  # Output
  # -------------------------------
  result <- list(
    metric = "SDG 6.4 - Water Efficiency",
    net_consumption_m3 = consumption,
    recycling_rate_percent = round(recycle_rate, 2)
  )

  return(result)
}
