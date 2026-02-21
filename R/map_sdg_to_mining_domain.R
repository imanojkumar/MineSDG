#' Map SDG Indicator to Mining-Sector Domain
#'
#' Classifies an SDG goal or indicator into a mining-sector
#' sustainability domain. Returns structured interpretation
#' including domain classification, relevance score (1–5),
#' and strategic narrative explanation.
#'
#' @param indicator Character. Optional SDG indicator code (e.g., "15.3.1").
#' @param goal Numeric (1–17). Optional SDG goal number.
#'
#' At least one of `indicator` or `goal` must be provided.
#'
#' @return A structured list containing:
#' \describe{
#'   \item{goal}{SDG goal number}
#'   \item{domain}{Mining sustainability domain}
#'   \item{relevance_score}{Numeric score (1–5)}
#'   \item{narrative}{Mining-sector strategic interpretation}
#' }
#'
#' @examples
#' \dontrun{
#' map_sdg_to_mining_domain(indicator = "15.3.1")
#' map_sdg_to_mining_domain(goal = 13)
#' }
#'
#' @export
map_sdg_to_mining_domain <- function(indicator = NULL, goal = NULL) {

  # -----------------------------
  # Input validation
  # -----------------------------
  if (is.null(indicator) && is.null(goal)) {
    stop("Provide at least one of `indicator` or `goal`.",
         call. = FALSE)
  }

  # If indicator provided → derive goal
  if (!is.null(indicator)) {
    validate_sdg_indicator(indicator)
    meta <- get_sdg_metadata()
    goal <- meta$goal[meta$indicator == indicator][1]
  }

  if (!is.numeric(goal) || length(goal) != 1 ||
      goal < 1 || goal > 17) {
    stop("`goal` must be numeric between 1 and 17.",
         call. = FALSE)
  }

  # -----------------------------
  # Domain mapping table
  # -----------------------------
  mapping <- list(
    "1"  = list("Economic Development", 3,
                "Poverty dynamics influence regional mining stability and social license risk."),
    "2"  = list("Community & Social Impact", 3,
                "Food security intersects with land use and community relations."),
    "3"  = list("Health & Safety", 5,
                "Health metrics relate directly to worker safety and community exposure risks."),
    "4"  = list("Education & Workforce", 4,
                "Education levels affect workforce quality and technical capacity."),
    "5"  = list("Community & Social Impact", 3,
                "Gender equity influences workforce diversity and ESG positioning."),
    "6"  = list("Water & Resource Efficiency", 5,
                "Water management is a critical operational and ESG risk factor."),
    "7"  = list("Climate & Energy", 4,
                "Energy transition affects cost structure and emissions profile."),
    "8"  = list("Economic Development", 4,
                "Mining contributes to GDP and employment growth metrics."),
    "9"  = list("Economic Development", 3,
                "Infrastructure supports logistics and supply chain efficiency."),
    "10" = list("Community & Social Impact", 3,
                "Inequality may affect community acceptance and project risk."),
    "11" = list("Community & Social Impact", 3,
                "Urban development influences mining regional integration."),
    "12" = list("Water & Resource Efficiency", 4,
                "Responsible production links to waste management and circular mining."),
    "13" = list("Climate & Energy", 5,
                "Climate action is central to decarbonization and transition risk."),
    "14" = list("Biodiversity & Land", 4,
                "Marine ecosystems may be impacted by tailings and coastal operations."),
    "15" = list("Biodiversity & Land", 5,
                "Land rehabilitation and biodiversity restoration are core mining metrics."),
    "16" = list("Governance & Institutions", 4,
                "Institutional quality influences permitting and corruption risk."),
    "17" = list("Governance & Institutions", 2,
                "Partnerships affect ESG collaboration but have indirect operational exposure.")
  )

  result <- mapping[[as.character(goal)]]

  output <- list(
    goal = goal,
    domain = result[[1]],
    relevance_score = result[[2]],
    narrative = result[[3]]
  )

  class(output) <- "minesdg_domain_mapping"

  return(output)
}
