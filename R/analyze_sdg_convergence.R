#' Analyze SDG Convergence
#'
#' Tests beta-convergence across countries for an SDG indicator.
#'
#' @param data A data.table returned by fetch_sdg_country_data().
#' @param base_year Optional base year. If NULL, earliest year is used.
#' @param final_year Optional final year. If NULL, latest year is used.
#'
#' @return A data.table with convergence statistics per indicator.
#'
#' @export
analyze_sdg_convergence <- function(data,
                                    base_year = NULL,
                                    final_year = NULL) {

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

  result <- merged[, {

    if (.N < 3) {
      list(
        beta = NA_real_,
        convergence_type = "Insufficient data"
      )
    } else {

      model <- tryCatch(
        stats::lm(growth_rate ~ value_base),
        error = function(e) NULL
      )

      if (is.null(model)) {
        list(
          beta = NA_real_,
          convergence_type = "Undetermined"
        )
      } else {

        beta_val <- stats::coef(model)[2]

        convergence_type <-
          ifelse(beta_val < 0,
                 "Convergence",
                 "Divergence")

        list(
          beta = beta_val,
          convergence_type = convergence_type
        )
      }
    }

  }, by = indicator]

  return(result[])
}
