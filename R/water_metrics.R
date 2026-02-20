#' Calculate Water Use Efficiency (SDG 6.4)
#'
#' This function calculates water use efficiency and recycling rates based on
#' Global Reporting Initiative (GRI 303) standards.
#'
#' @param withdrawal_m3 Numeric. Total water withdrawn from all sources in cubic meters.
#' @param discharge_m3 Numeric. Total water discharged in cubic meters.
#' @param recycled_m3 Numeric. Total water recycled/reused in cubic meters.
#'
#' @return A list containing:
#' \itemize{
#'   \item \code{metric}: The name of the calculated metric.
#'   \item \code{net_consumption_m3}: Net water consumed (Withdrawal - Discharge).
#'   \item \code{recycling_rate_percent}: Percentage of total water use that is recycled.
#' }
#' @export
#'
#' @examples
#' calculate_water_efficiency(withdrawal_m3 = 50000, discharge_m3 = 10000, recycled_m3 = 20000)
calculate_water_efficiency <- function(withdrawal_m3, discharge_m3, recycled_m3) {

  # Error handling: Ensure inputs are positive numbers
  if (any(c(withdrawal_m3, discharge_m3, recycled_m3) < 0)) {
    stop("Input values must be non-negative numbers.")
  }

  # 1. Net Water Consumption (GRI 303-5)
  consumption <- withdrawal_m3 - discharge_m3

  # 2. Total Water Demand (Withdrawal + Recycled)
  total_demand <- withdrawal_m3 + recycled_m3

  # 3. Recycling Rate (Circular Economy Metric)
  # Avoid division by zero
  if (total_demand == 0) {
    recycle_rate <- 0
  } else {
    recycle_rate <- (recycled_m3 / total_demand) * 100
  }

  return(list(
    metric = "SDG 6.4 - Water Efficiency",
    net_consumption_m3 = consumption,
    recycling_rate_percent = round(recycle_rate, 2)
  ))
}
