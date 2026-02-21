# List SDG Indicators and Descriptions

Retrieves the official list of SDG indicators, including indicator
codes, descriptions, goal numbers, and tier classification.

## Usage

``` r
list_sdg_indicators(goal = NULL)
```

## Arguments

- goal:

  Numeric (1–17). Optional SDG goal number to filter indicators.

## Value

A data.table containing:

- goal:

  SDG goal number

- indicator:

  Indicator code

- description:

  Indicator description

- tier:

  Tier classification

## Details

Uses internally cached metadata via
[`get_sdg_metadata()`](get_sdg_metadata.md).

## Examples

``` r
if (FALSE) { # \dontrun{
list_sdg_indicators()
list_sdg_indicators(goal = 15)
} # }
```
