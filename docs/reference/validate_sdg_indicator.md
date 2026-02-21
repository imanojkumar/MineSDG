# Validate SDG Indicator Code

Checks whether a provided SDG indicator code exists in the official UN
SDG indicator database.

## Usage

``` r
validate_sdg_indicator(indicator, goal = NULL)
```

## Arguments

- indicator:

  Character. SDG indicator code (e.g., "15.3.1").

- goal:

  Numeric (1–17). Optional SDG goal number for consistency check.

## Value

Logical TRUE if valid. Stops with error if invalid.

## Details

Optionally verifies consistency between indicator and goal.

Uses internally cached metadata via
[`get_sdg_metadata()`](get_sdg_metadata.md).

## Examples

``` r
if (FALSE) { # \dontrun{
validate_sdg_indicator("15.3.1")
validate_sdg_indicator("15.3.1", goal = 15)
} # }
```
