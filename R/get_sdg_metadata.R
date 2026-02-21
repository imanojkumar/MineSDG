#' Internal: Get SDG Metadata (Cached)
#'
#' Retrieves SDG metadata from UN API and caches it
#' for the current R session.
#'
#' @keywords internal
get_sdg_metadata <- function() {

  # Return cached version if available
  if (!is.null(.sdg_env$metadata)) {
    return(.sdg_env$metadata)
  }

  response <- tryCatch({
    httr2::request("https://unstats.un.org/SDGAPI/v1/sdg/Indicator/List") |>
      httr2::req_perform()
  }, error = function(e) {
    stop(
      paste0("Unable to retrieve SDG metadata.\n",
             "Technical message:\n", e$message),
      call. = FALSE
    )
  })

  parsed <- httr2::resp_body_json(response)

  if (!is.list(parsed)) {
    stop("Unexpected metadata structure.", call. = FALSE)
  }

  # Convert once to data.table
  metadata_dt <- data.table::rbindlist(lapply(parsed, function(x) {
    data.table::data.table(
      goal        = as.numeric(x$goal),
      indicator   = x$code,
      description = x$description,
      tier        = x$tier
    )
  }), fill = TRUE)

  # Store in cache
  .sdg_env$metadata <- metadata_dt

  return(metadata_dt)
}
