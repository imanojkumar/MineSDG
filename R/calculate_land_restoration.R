#' Calculate Land Restoration Rehabilitation Rate
#'
#' Computes the rehabilitation rate of disturbed mining land in alignment with
#' SDG 15.3 (Land Degradation Neutrality). The function evaluates the percentage
#' of disturbed land that has been restored or revegetated and reports the
#' remaining unrestored area.
#'
#' The rehabilitation rate is calculated as:
#' \deqn{(rehabilitated\_area\_ha / disturbed\_area\_ha) * 100}
#'
#' If \code{disturbed_area_ha} is 0, the function safely returns 0 percent restored
#' to avoid division-by-zero errors.
#'
#' @param disturbed_area_ha Numeric. Total land disturbed by mining activities (in hectares).
#'   Must be a non-negative number.
#' @param rehabilitated_area_ha Numeric. Total land rehabilitated or revegetated (in hectares).
#'   Must be a non-negative number.
#'
#' @return A named list containing:
#' \describe{
#'   \item{metric}{Character string. "SDG 15.3 - Land Restoration"}
#'   \item{percent_restored}{Numeric. Rehabilitation rate rounded to 2 decimal places.}
#'   \item{unrestored_area_ha}{Numeric. Remaining disturbed land not yet restored (in hectares).}
#' }
#'
#' @examples
#' calculate_land_restoration(100, 40)
#'
#' calculate_land_restoration(
#'   disturbed_area_ha = 250,
#'   rehabilitated_area_ha = 180
#' )
#'
#' calculate_land_restoration(0, 0)
#'
#' @export
calculate_land_restoration <- function(disturbed_area_ha,
                                       rehabilitated_area_ha) {

  # -------------------------------
  # Input validation
  # -------------------------------
  if (!is.numeric(disturbed_area_ha) || length(disturbed_area_ha) != 1 || is.na(disturbed_area_ha)) {
    stop("`disturbed_area_ha` must be a single non-negative numeric value.", call. = FALSE)
  }

  if (!is.numeric(rehabilitated_area_ha) || length(rehabilitated_area_ha) != 1 || is.na(rehabilitated_area_ha)) {
    stop("`rehabilitated_area_ha` must be a single non-negative numeric value.", call. = FALSE)
  }

  if (disturbed_area_ha < 0) {
    stop("`disturbed_area_ha` cannot be negative.", call. = FALSE)
  }

  if (rehabilitated_area_ha < 0) {
    stop("`rehabilitated_area_ha` cannot be negative.", call. = FALSE)
  }

  # -------------------------------
  # Edge case: zero disturbed land
  # -------------------------------
  if (disturbed_area_ha == 0) {
    return(list(
      metric = "SDG 15.3 - Land Restoration",
      percent_restored = 0,
      unrestored_area_ha = 0
    ))
  }

  # -------------------------------
  # Core calculation
  # -------------------------------
  percent_restored_raw <- (rehabilitated_area_ha / disturbed_area_ha) * 100
  percent_restored <- round(percent_restored_raw, 2)

  unrestored_area_ha <- disturbed_area_ha - rehabilitated_area_ha
  unrestored_area_ha <- max(unrestored_area_ha, 0)

  # -------------------------------
  # Output
  # -------------------------------
  result <- list(
    metric = "SDG 15.3 - Land Restoration",
    percent_restored = percent_restored,
    unrestored_area_ha = unrestored_area_ha
  )

  return(result)
}
