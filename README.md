
# MineSDG

<!-- badges: start -->

[![R-CMD-check](https://github.com/imanojkumar/MineSDG/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/imanojkumar/MineSDG/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`MineSDG` is an R package designed to help mining, minerals, and metals
professionals quantify their impact on United Nations Sustainable
Development Goals (SDGs).

Unlike generic text-mining SDG tools, `MineSDG` focuses on quantitative
operational data specific to the natural resources sector (e.g., water
withdrawal volumes, land disturbance ratios, rehabilitation rates).

# Project Roadmap

This package is currently under active development. The initial release
will focus on:

- SDG 6 (Clean Water & Sanitation): Calculating water recycling
  efficiency and withdrawal intensity.

- SDG 15 (Life on Land): Metrics for land disturbance
  vs. rehabilitation.

- Global Reporting Alignment: Computes metrics aligned with GRI (Global
  Reporting Initiative) Standards (specifically GRI 303 & 304) and SASB
  Metals & Mining standards.

## Installation

You can install the development version of `MineSDG` from
[GitHub](https://github.com/imanojkumar/MineSDG) like so:

``` r
# install.packages("devtools")
devtools::install_github("imanojkumar/MineSDG")
```

## Example

This is a basic example of how the package will work (functions coming
soon):

``` r
library(MineSDG)
# calculate_water_efficiency(withdrawal_m3 = 50000, discharge_m3 = 10000, recycled_m3 = 20000)
```
