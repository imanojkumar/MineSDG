#' Fetch Country-Level SDG Data from UN SDG API
#'
#' Retrieves Sustainable Development Goal (SDG) indicator data from the
#' official United Nations SDG API.
#'
#' The function supports filtering by goal, indicator code, ISO3 country code,
#' and year range. Data is returned as a high-performance \code{data.table}.
#'
#' Optionally, the fetched data can be saved to disk in CSV and/or RDS format.
#'
#' API Source:
#' \url{https://unstats.un.org/SDGAPI/v1/sdg/Indicator/Data}
#'
#' @param goal Numeric (1-17). Optional SDG goal number.
#' @param indicator Character. SDG indicator code (e.g., "15.3.1").
#' @param country Character. ISO3 country code (e.g., "IND", "AUS").
#' @param year_range Numeric vector of length 2 (start_year, end_year).
#' @param save Logical. If TRUE, saves data to disk. Default FALSE.
#' @param save_path Character. Directory path for saving data.
#'   Default: "./data/sdg_downloads/".
#' @param formats Character vector. Any combination of "csv", "rds".
#'   Default c("csv", "rds").
#'
#' @return A \code{data.table} containing SDG indicator data.
#'
#' @examples
#' \dontrun{
#' fetch_sdg_country_data(
#'   indicator = "15.3.1",
#'   country = "IND",
#'   year_range = c(2015, 2022),
#'   save = TRUE
#' )
#' }
#'
#' @export
fetch_sdg_country_data <- function(goal = NULL,
                                   indicator = NULL,
                                   country = NULL,
                                   year_range = NULL,
                                   save = FALSE,
                                   save_path = "./data/sdg_downloads/",
                                   formats = c("csv", "rds")) {

  # -----------------------------
  # Dependency checks
  # -----------------------------
  required_pkgs <- c("httr2", "jsonlite", "data.table")
  missing_pkgs <- required_pkgs[!vapply(required_pkgs, requireNamespace, logical(1), quietly = TRUE)]

  if (length(missing_pkgs) > 0) {
    stop(
      paste0(
        "Missing required packages: ",
        paste(missing_pkgs, collapse = ", "),
        "\nPlease install them using install.packages()."
      ),
      call. = FALSE
    )
  }

  # -----------------------------
  # Input validation
  # -----------------------------
  if (!is.null(goal) && (!is.numeric(goal) || goal < 1 || goal > 17)) {
    stop("`goal` must be numeric between 1 and 17.", call. = FALSE)
  }

  if (!is.null(year_range)) {
    if (!is.numeric(year_range) || length(year_range) != 2) {
      stop("`year_range` must be numeric vector of length 2.", call. = FALSE)
    }
  }

  if (!is.null(country) && nchar(country) != 3) {
    stop("`country` must be a valid ISO3 code (e.g., 'IND').", call. = FALSE)
  }

  # -----------------------------
  # Validate indicator (if provided)
  # -----------------------------
  if (!is.null(indicator)) {
    validate_sdg_indicator(indicator, goal)
  }

  # -----------------------------
  # Build query
  # -----------------------------
  base_url <- "https://unstats.un.org/SDGAPI/v1/sdg/Indicator/Data"

  query_list <- list()

  if (!is.null(indicator)) query_list$Indicator <- indicator
  if (!is.null(country)) query_list$AreaCode <- country
  if (!is.null(year_range)) {
    query_list$TimePeriodStart <- year_range[1]
    query_list$TimePeriodEnd   <- year_range[2]
  }

  # -----------------------------
  # API Request with error handling
  # -----------------------------
  response <- tryCatch({

    httr2::request(base_url) |>
      httr2::req_url_query(!!!query_list) |>
      httr2::req_perform()

  }, error = function(e) {

    stop(
      paste0(
        "\nUN SDG API request failed.\n\n",
        "Possible causes:\n",
        "- No internet connection\n",
        "- UN API temporarily unavailable\n",
        "- Invalid indicator or country code\n\n",
        "Technical message:\n", e$message
      ),
      call. = FALSE
    )
  })

  # -----------------------------
  # Parse JSON
  # -----------------------------
  parsed <- tryCatch({
    httr2::resp_body_json(response)
  }, error = function(e) {
    stop(
      paste0(
        "Failed to parse API response.\n",
        "The API structure may have changed.\n\n",
        "Technical message:\n", e$message
      ),
      call. = FALSE
    )
  })

  if (is.null(parsed$data) || length(parsed$data) == 0) {
    warning(
      "No data returned for specified filters.\n",
      "Verify indicator code, country ISO3 code, and year range.",
      call. = FALSE
    )
    return(data.table::data.table())
  }

  # -----------------------------
  # Convert to data.table
  # -----------------------------
  dt <- data.table::rbindlist(lapply(parsed$data, function(x) {
    data.table::data.table(
      indicator = x$indicator,
      country   = x$areaCode,
      year      = as.numeric(x$timePeriod),
      value     = suppressWarnings(as.numeric(x$value)),
      unit      = x$unit
    )
  }), fill = TRUE)

  # -----------------------------
  # Inform user
  # -----------------------------
  message(
    "\nSDG Data Successfully Retrieved\n",
    "---------------------------------\n",
    "Indicator: ", ifelse(is.null(indicator), "Multiple", indicator), "\n",
    "Country: ", ifelse(is.null(country), "Multiple", country), "\n",
    "Years: ", min(dt$year, na.rm = TRUE), "-", max(dt$year, na.rm = TRUE), "\n",
    "Observations: ", nrow(dt), "\n"
  )

  # -----------------------------
  # Optional Saving
  # -----------------------------
  if (isTRUE(save)) {

    if (!dir.exists(save_path)) {
      dir.create(save_path, recursive = TRUE)
      message("Created directory: ", normalizePath(save_path))
    }

    file_stub <- paste0(
      "sdg_",
      ifelse(is.null(indicator), "multi", gsub("\\.", "_", indicator)),
      "_",
      ifelse(is.null(country), "multi", country),
      "_",
      format(Sys.Date())
    )

    if ("csv" %in% formats) {
      csv_path <- file.path(save_path, paste0(file_stub, ".csv"))
      data.table::fwrite(dt, csv_path)
      message("Saved CSV: ", normalizePath(csv_path))
    }

    if ("rds" %in% formats) {
      rds_path <- file.path(save_path, paste0(file_stub, ".rds"))
      saveRDS(dt, rds_path)
      message("Saved RDS: ", normalizePath(rds_path))
      message("To reload: readRDS('", normalizePath(rds_path), "')")
    }
  }

  return(dt[])
}
