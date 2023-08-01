# Spatial Social Polarization Database: Index of Concentration at the Extremes (ICE)
A database of pre-calculated spatial social polarization variables and the code used to calculate them. 

## Background
The Index of Concentration at the Extremes (ICE), developed by sociologist Douglas Massey, compares the % of population in an area that are in a 'privileged' group and the % of a population in the same area that are in the 'disadvantaged' group:

$`ICE_i = (A_i - P_i)/T_i `$     
Where $`A_i`$ is the number of people in an area $`i`$ that belong to the privileged group, and $`P_i`$ is the number of people in the area that belong to the disadvantaged group, and $`T_i`$ is the total number of people in area $`i`$. ICE values range from -1 (most concentrated disadvantage) to +1 (most concentrated privilege). 

ICE can be calculated for any combination of privileged/disadvantaged: for example, ICE for income could compare wealthy to poor population, ICE for race might compare Black to white population, and ICE for race/ethnicity/income might compare the concentration of high-income non-Hispanic whites to low-income people of color. This makes ICE a highly versatile measure of segregation.

## About this Repository
### Available Data
Download tables of ICE values as .csv files at the county, tract, and Zip Code Tabulation Area (ZCTA) level in the "ICE" folder. 
Files are named with either "acs", indicating that census data were extracted from American Community Survey 5-year estimates or "dec", indicating that Decennial Census data were used.
#### Data Dictionary
| Variable       | Description | 
| ---------------|--------------|
|GEOID | [US Census Bureau Geographic Identifier](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)|

|Variable|Privileged Group|Disadvantaged Group|
| -------|----------------|-------------------|
|ICEincome |High income (need definition, top quintile?) |Low income (need definition, bottom quintile?)|
|ICEraceeth |Non-Hispanic White |Non-Hispanic Black |
|ICEhome |Home owners |Renters |
|ICEincwb |High-income White |Low-income Black |
|ICEedu |? |? |
|ICElanguage |? |? |

### Code 
The code used to create ICE variables can be found in Code > ice_machine.R. Additional ICE measures can be created by modifying the ice_acs_formulas.csv and ice_dec_formulas.csv files--here, privileged and disadvantaged groups are defined using their census variables (**insert link to census APIs for variables names).

## Comments
Here is where we can comment on missing data and some of the nuances.
