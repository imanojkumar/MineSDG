# MineSDG-introduction

## Introduction

MineSDG provides tools to explore and retrieve official Sustainable
Development Goal (SDG) indicator data from the United Nations SDG API.

The package includes:

- Metadata exploration
- Indicator validation
- Country-level data retrieval
- Optional data persistence
- Session-level metadata caching

## Listing SDG Indicators

To view all indicators:

``` r
head(list_sdg_indicators())
```

To list indicators under a specific goal:

``` r
list_sdg_indicators(goal = 15)
```

## Validating Indicators

``` r
validate_sdg_indicator("15.3.1")
```

Goal consistency validation:

``` r
validate_sdg_indicator("15.3.1", goal = 15)
```

## Fetching Data for a Single Indicator

``` r
dt <- fetch_sdg_country_data(
  indicator = "15.3.1",
  country = "IND",
  year_range = c(2015, 2020)
)

head(dt)
```

## Fetching All Indicators Under a Goal

``` r
dt_goal <- fetch_sdg_country_data(
  goal = 15,
  country = "IND",
  year_range = c(2015, 2020)
)

head(dt_goal)
```

## Saving Data

``` r
fetch_sdg_country_data(
  indicator = "15.3.1",
  country = "IND",
  year_range = c(2015, 2020),
  save = TRUE
)
```

Files are saved under:

`./data/sdg_downloads/`
