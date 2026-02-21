# Map SDG Indicator to Mining-Sector Domain

Classifies an SDG goal or indicator into a mining-sector sustainability
domain. Returns structured interpretation including domain
classification, relevance score (1–5), and strategic narrative
explanation.

## Usage

``` r
map_sdg_to_mining_domain(indicator = NULL, goal = NULL)
```

## Arguments

- indicator:

  Character. Optional SDG indicator code (e.g., "15.3.1").

- goal:

  Numeric (1–17). Optional SDG goal number.

  At least one of `indicator` or `goal` must be provided.

## Value

A structured list containing:

- goal:

  SDG goal number

- domain:

  Mining sustainability domain

- relevance_score:

  Numeric score (1–5)

- narrative:

  Mining-sector strategic interpretation

## Examples

``` r
if (FALSE) { # \dontrun{
map_sdg_to_mining_domain(indicator = "15.3.1")
map_sdg_to_mining_domain(goal = 13)
} # }
```
