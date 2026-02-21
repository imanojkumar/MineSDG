# MineSDG - SDG Analytics & Mining-Sector Intelligence

------------------------------------------------------------------------

## 1. Introduction

MineSDG provides tools to explore and retrieve official Sustainable
Development Goal (SDG) indicator data from the United Nations SDG API.

The package includes:

- Metadata exploration
- Indicator validation
- Country-level data retrieval
- Optional data persistence
- Session-level metadata caching

------------------------------------------------------------------------

## 2. SDG Analytics Layer

### Listing SDG Indicators

To view all indicators:

``` r
head(list_sdg_indicators())
```

To list indicators under a specific goal:

``` r
list_sdg_indicators(goal = 15)
```

------------------------------------------------------------------------

### Validating Indicators

``` r
validate_sdg_indicator("15.3.1")
```

Goal consistency validation:

``` r
validate_sdg_indicator("15.3.1", goal = 15)
```

------------------------------------------------------------------------

### Fetching Data for a Single Indicator

``` r
dt <- fetch_sdg_country_data(
  indicator = "15.3.1",
  country = "IND",
  year_range = c(2015, 2020)
)

head(dt)
```

------------------------------------------------------------------------

### Fetching All Indicators Under a Goal

``` r
dt_goal <- fetch_sdg_country_data(
  goal = 15,
  country = "IND",
  year_range = c(2015, 2020)
)

head(dt_goal)
```

------------------------------------------------------------------------

### Saving Data

``` r
fetch_sdg_country_data(
  indicator = "15.3.1",
  country = "IND",
  year_range = c(2015, 2020),
  save = TRUE
)
```

Files are saved under:

``` r
./data/sdg_downloads/
```

------------------------------------------------------------------------

### Advanced Analytics

MineSDG 0.2.0 expands the package beyond data retrieval into a complete
SDG analytics engine.

The following analytical layers are now available:

- Trend analysis
- Stability and volatility diagnostics
- Benchmark comparison
- Convergence testing
- Executive-ready narrative generation
- Visualization utilities

------------------------------------------------------------------------

### Trend Analysis

``` r
trend <- analyze_sdg_trend(dt)
trend
```

This function computes:

- Absolute change
- Percent change
- CAGR (Compound Annual Growth Rate)
- Linear trend slope
- Trend direction (Increasing / Decreasing / Stable)

------------------------------------------------------------------------

### Stability & Volatility Diagnostics

``` r
stability <- compute_sdg_stability(dt)
stability
```

Includes:

- Standard deviation
- Coefficient of variation
- Volatility index
- Stability classification

These metrics are especially useful for ESG risk evaluation and
operational performance diagnostics.

------------------------------------------------------------------------

### Benchmarking Performance

``` r
benchmark <- benchmark_sdg_performance(dt)
benchmark
```

Outputs:

- Deviation from benchmark
- Percent gap
- Z-score
- Ranking
- Performance category (Strong / Moderate / Weak)

------------------------------------------------------------------------

### Convergence Analysis

``` r
convergence <- analyze_sdg_convergence(dt)
convergence
```

This tests beta-convergence across countries, helping assess whether
lagging countries are catching up in SDG performance.

------------------------------------------------------------------------

### Executive Summary Generation

``` r
summary_text <- generate_sdg_executive_summary(trend, benchmark)
cat(summary_text)
```

Produces narrative, board-ready interpretation suitable for:

- ESG reports
- Policy briefs
- Academic summaries
- Strategic reviews

------------------------------------------------------------------------

### Visualization Layer

MineSDG includes publication-ready visualization tools:

``` r
plot_sdg_trend(dt)
plot_sdg_benchmark(benchmark)
plot_sdg_volatility(stability)
plot_sdg_convergence(dt)
```

All plots use ggplot2 (optional dependency) and follow minimal,
publication-ready styling.

------------------------------------------------------------------------

## 3. Mining-Sector Interpretation Layer

MineSDG now includes a sector-specific interpretation layer tailored for
mining sustainability analytics.

This enables translation of SDG indicators into mining-relevant
sustainability domains, relevance scoring, and strategic narrative
interpretation.

------------------------------------------------------------------------

### Mapping SDG to Mining Domains

``` r
map_sdg_to_mining_domain(indicator = "15.3.1")
```

Example output:

- *Goal:* 15
- *Domain:* Biodiversity & Land
- *Relevance Score:* 5
- *Narrative:* Land degradation, rehabilitation, and biodiversity
  restoration are core mining sustainability metrics.

------------------------------------------------------------------------

### Domain Categories

The following mining sustainability domains are currently defined:

- Climate & Energy
- Water & Resource Efficiency
- Biodiversity & Land
- Community & Social Impact
- Governance & Institutions
- Economic Development
- Health & Safety
- Education & Workforce

This layer enables sector-aware ESG analytics beyond generic SDG
evaluation.

------------------------------------------------------------------------

### Mining Risk Engine

``` r
dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
generate_mining_risk_profile(dt, indicator = "15.3.1")
```

------------------------------------------------------------------------

### Summary

MineSDG now supports a full analytical workflow:

Data Retrieval → Trend Diagnostics → Stability Analysis → Benchmarking →
Convergence Testing → Executive Reporting → Visualization

This positions MineSDG as a research-grade SDG analytics framework
suitable for:

- ESG reporting
- Policy evaluation
- Academic research
- Mining-sector sustainability assessment
