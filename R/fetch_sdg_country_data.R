#' Fetch Country-Level SDG Data from UN SDG API
#'
#' Retrieves Sustainable Development Goal (SDG) indicator data from the
#' official United Nations SDG API.
#'
#' At least one of `goal` or `indicator` must be provided.
#'
#' - If `indicator` is supplied → fetch that specific indicator.
#' - If only `goal` is supplied → fetch all indicators under that goal.
#' - If both are supplied → consistency is validated.
#'
#' `country` and `year_range` act as filters.
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
#' @return A data.table containing SDG indicator data.
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
      paste0("Missing required packages: ",
             paste(missing_pkgs, collapse = ", "),
             "\nPlease install them using install.packages()."),
      call. = FALSE
    )
  }

  # -----------------------------
  # Require goal or indicator
  # -----------------------------
  if (is.null(goal) && is.null(indicator)) {
    stop("You must provide at least one of `goal` or `indicator`.",
         call. = FALSE)
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
  # Determine indicator list (CACHED)
  # -----------------------------
  if (!is.null(indicator)) {

    indicator_list <- indicator

  } else {

    metadata_dt <- get_sdg_metadata()

    indicator_list <- metadata_dt[goal == !!goal, indicator]

    if (length(indicator_list) == 0) {
      stop(
        paste0("No indicators found under Goal ", goal, "."),
        call. = FALSE
      )
    }

    message(
      "Fetching ", length(indicator_list),
      " indicators under Goal ", goal, ".\n",
      "This may take some time."
    )
  }

  # -----------------------------
  # Fetch data
  # -----------------------------
  base_url <- "https://unstats.un.org/SDGAPI/v1/sdg/Indicator/Data"
  all_results <- data.table::data.table()

  for (ind in indicator_list) {

    query_list <- list(Indicator = ind)

    if (!is.null(country)) query_list$AreaCode <- country
    if (!is.null(year_range)) {
      query_list$TimePeriodStart <- year_range[1]
      query_list$TimePeriodEnd   <- year_range[2]
    }

    response <- tryCatch({
      httr2::request(base_url) |>
        httr2::req_url_query(!!!query_list) |>
        httr2::req_perform()
    }, error = function(e) {
      warning(
        paste0("Failed to fetch indicator ", ind,
               ". Skipping.\nTechnical message:\n", e$message),
        call. = FALSE
      )
      return(NULL)
    })

    if (is.null(response)) next

    parsed <- httr2::resp_body_json(response)

    if (is.null(parsed$data) || length(parsed$data) == 0) next

    dt <- data.table::rbindlist(lapply(parsed$data, function(x) {
      data.table::data.table(
        indicator = x$indicator,
        country   = x$areaCode,
        year      = as.numeric(x$timePeriod),
        value     = suppressWarnings(as.numeric(x$value)),
        unit      = x$unit
      )
    }), fill = TRUE)

    all_results <- data.table::rbindlist(list(all_results, dt), fill = TRUE)
  }

  if (nrow(all_results) == 0) {
    warning("No data returned for specified filters.", call. = FALSE)
    return(all_results)
  }

  message(
    "\nSDG Data Successfully Retrieved\n",
    "---------------------------------\n",
    "Indicators retrieved: ", length(unique(all_results$indicator)), "\n",
    "Observations: ", nrow(all_results), "\n"
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
      ifelse(is.null(goal), "multi", paste0("goal_", goal)),
      "_",
      format(Sys.Date())
    )

    if ("csv" %in% formats) {
      csv_path <- file.path(save_path, paste0(file_stub, ".csv"))
      data.table::fwrite(all_results, csv_path)
      message("Saved CSV: ", normalizePath(csv_path))
    }

    if ("rds" %in% formats) {
      rds_path <- file.path(save_path, paste0(file_stub, ".rds"))
      saveRDS(all_results, rds_path)
      message("Saved RDS: ", normalizePath(rds_path))
      message("To reload: readRDS('", normalizePath(rds_path), "')")
    }
  }

  return(all_results[])
}
