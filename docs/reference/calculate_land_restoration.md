# Calculate Land Restoration Rehabilitation Rate

Computes the rehabilitation rate of disturbed mining land in alignment
with SDG 15.3 (Land Degradation Neutrality). The function evaluates the
percentage of disturbed land that has been restored or revegetated and
reports the remaining unrestored area.

## Usage

``` r
calculate_land_restoration(disturbed_area_ha, rehabilitated_area_ha)
```

## Arguments

- disturbed_area_ha:

  Numeric. Total land disturbed by mining activities (in hectares). Must
  be a non-negative number.

- rehabilitated_area_ha:

  Numeric. Total land rehabilitated or revegetated (in hectares). Must
  be a non-negative number.

## Value

A named list containing:

- metric:

  Character string. "SDG 15.3 - Land Restoration"

- percent_restored:

  Numeric. Rehabilitation rate rounded to 2 decimal places.

- unrestored_area_ha:

  Numeric. Remaining disturbed land not yet restored (in hectares).

## Details

The rehabilitation rate is calculated as: \$\$(rehabilitated\\area\\ha /
disturbed\\area\\ha) \* 100\$\$

If `disturbed_area_ha` is 0, the function safely returns 0 percent
restored to avoid division-by-zero errors.

## Examples

``` r
calculate_land_restoration(100, 40)
#> $metric
#> [1] "SDG 15.3 - Land Restoration"
#> 
#> $percent_restored
#> [1] 40
#> 
#> $unrestored_area_ha
#> [1] 60
#> 

calculate_land_restoration(
  disturbed_area_ha = 250,
  rehabilitated_area_ha = 180
)
#> $metric
#> [1] "SDG 15.3 - Land Restoration"
#> 
#> $percent_restored
#> [1] 72
#> 
#> $unrestored_area_ha
#> [1] 70
#> 

calculate_land_restoration(0, 0)
#> $metric
#> [1] "SDG 15.3 - Land Restoration"
#> 
#> $percent_restored
#> [1] 0
#> 
#> $unrestored_area_ha
#> [1] 0
#> 
```
