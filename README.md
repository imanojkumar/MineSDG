
<br>

<p align="center">

[![R-CMD-check](https://github.com/imanojkumar/MineSDG/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/imanojkumar/MineSDG/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)

</p>

<br>

# MineSDG: Strategic Analytics & Sector Intelligence

<!-- badges: start -->

[![R-CMD-check](https://github.com/imanojkumar/MineSDG/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/imanojkumar/MineSDG/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

<b>MineSDG</b> is a research-grade R framework designed to bridge the gap between raw operational data and the United Nations Sustainable Development Goals (SDGs). While generic tools rely on text-mining, `MineSDG` utilizes a quantitative "Sector Intelligence" layer to provide deep, actionable insights into mining sustainability.

The framework is architected for multi-source data agility, enabling users to integrate global sustainability indicators with regional benchmarks and internal corporate metrics to create a unified "*Single Source of Truth*" for ESG performance.

It transforms fragmented metrics into executive-ready intelligence through four analytical pillars:

- <b>Agnostic Data Integration</b>: Robust retrieval and harmonization of global, regional, and sector-specific sustainability datasets.

- <b>Advanced Statistical Diagnostics</b>: Trend analysis, volatility indexing, and convergence testing.

- <b>Mining-Specific Interpretation</b>: Mapping indicators to industry domains like Biodiversity & Land or Resource Efficiency.

- <b>Strategic Reporting</b>: Automated generation of board-ready executive summaries and publication-quality visualizations.

## Key Capabilities

- <b>SDG Analytics Engine</b>: Perform CAGR calculations, linear trend slopes, and percent change analysis on sustainability metrics.

- <b>Stability & Risk Diagnostics</b>: Evaluate ESG risk through volatility indexing and coefficient of variation.

- <b>Benchmarking & Ranking</b>: Compare performance against global benchmarks with automated Z-scoring and percentile ranking.

- <b>Mining Risk Engine</b>: Generate sector-aware risk profiles by integrating indicator trends with domain-specific relevance scoring.

- <b>Composite ESG Indexing</b>: Build weighted indices (e.g., Biodiversity, Climate, or Social Impact) tailored to the mining sector's materiality.


## Installation

The stable version (v0.1.0) of `MineSDG` is available as a formal release. You can install it directly from <a href="https://github.com/imanojkumar/MineSDG/releases/tag/v0.1.0" target="_blank">GitHub</a> like so:


``` r
# install.packages("devtools")
devtools::install_github("imanojkumar/MineSDG@v0.1.0")
```

For the latest development features (v0.2.0.9000), including the `Mining Risk Engine`, `Convergence Analysis`, and `Composite ESG Indexing`:

``` r
# install.packages("devtools")
devtools::install_github("imanojkumar/MineSDG")
```

## Quick Start: Strategic Workflow

**MineSDG** leverages open-access global data. No API keys are required for standard retrieval, allowing you to move from raw data to sector-specific intelligence in seconds:

The following example demonstrates how to retrieve data, analyze trends, and generate a mining-specific risk profile:

``` r
library(MineSDG)

# 1. Retrieve Global Data (e.g., Land Degradation / SDG 15.3.1)
# Accesses the official UN SDG API directly
dt <- fetch_sdg_country_data(
  indicator  = "15.3.1",
  country    = "IND",
  year_range = c(2015, 2020)
)

# 2. Generate Sector-Specific Risk Profile
# Integrates trend, volatility, and domain relevance
risk_profile <- generate_mining_risk_profile(dt, indicator = "15.3.1")

# 3. View Executive Summary
# Produces board-ready narrative interpretation
cat(risk_profile$executive_summary)

# 4. Visualize the Strategic Trend
plot_sdg_trend(dt)
```

<br><br>

## Citation & Data Acknowledgement

If you use **MineSDG** in your research, ESG reports, or strategic reviews, please cite it as follows:

### Citation - APA 7th Edition:

    Kumar, M. (2026). MineSDG: Strategic Analytics & Sector Intelligence for Mining Sustainability (Version 0.1.0) [R package]. GitHub. https://github.com/imanojkumar/MineSDG

### BibTeX:

    @Manual{,
      title = {MineSDG: Strategic Analytics & Sector Intelligence for Mining Sustainability},
      author = {Manoj Kumar},
      year = {2026},
      note = {R package version 0.1.0},
      url = {https://github.com/imanojkumar/MineSDG},
    }

### Data Acknowledgement

**MineSDG** acts as a client to the **United Nations Sustainable Development Goals API**. Users of this package are bound by the <a href="https://www.un.org/en/about-us/terms-of-use" target="_blank">United Nations Data Terms of Use</a>. We gratefully acknowledge the UN Statistics Division for maintaining the global SDG indicator database.



<br><br><br>
