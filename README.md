# Spatial Social Polarization Database

A database of pre-calculated spatial social polarization variables and the code used to calculate them. The purpose of this database is to remove computational barriers which prevent the wider use of useful indices in health research. This database is designed to provide an auditable and reproducible source of indices data.

## Authors

-   Sam Jaros
-   Lisa Frueh
-   Dr. Hoda Abdel Magid
-   Dr. Gina Lovasi

## Index of the Concentration at the Extremes

The Index of Concentration at the Extremes (ICE), developed by sociologist Douglas Massey, compares the % of population in an area that are in a 'privileged' group and the % of a population in the same area that are in the 'deprived' group:

$`ICE_i = (A_i - P_i)/T_i`$\
Where $`A_i`$ is the number of people in an area $`i`$ that belong to the advantaged group, and $`P_i`$ is the number of people in the area that belong to the disadvantaged group, and $`T_i`$ is the total number of people in area $`i`$. ICE values range from -1 (most concentrated disadvantage) to +1 (most concentrated privilege).

ICE can be calculated for any combination of privileged/disadvantaged: for example, ICE for income could compare wealthy to poor population, ICE for race might compare Black to white population, and ICE for race/ethnicity/income might compare the concentration of high-income non-Hispanic whites to low-income people of color. This makes ICE a highly versatile measure of segregation.

Based on the user's specifications, the code will use American Community Survey or Decennial Census data for the specified year at the specified geographic level to retrieve the data and calculate the ICE.

### Available ICE indices

***ACS ICE variables:***

|Name                 |Privileged                 |Deprived                             |2010   |2011              |2012              |
|---------------------|---------------------------|-------------------------------------|-------|------------------|------------------|
|Income               |\>\$100k                   |\<\$25k                              |No ZCTA|:white_check_mark:|:white_check_mark:|
|Race/ethnicity       |White non-Hispanic         |Black non-Hispanic                   |No ZCTA|:white_check_mark:|:white_check_mark:|
|Home ownership       |Owner-occupied unit        |Renter-occupied unit                 |No ZCTA|:white_check_mark:|:white_check_mark:|
|Income/race          |White non-Hispanic \>\$100k|Black alone \<\$25k                  |No ZCTA|:white_check_mark:|:white_check_mark:|
|Income/race/ethnicity|White non-Hispanic \>\$100k|\<\$25k \- White non-Hispanic \<\$25k|No ZCTA|:white_check_mark:|:white_check_mark:|
|Education            |Bachelor's degree or more  |Less than a high school degree       |:x:    |:x:               |:white_check_mark:|
|Language             |English only               |Spanish or Spanish Creole            |No ZCTA|:white_check_mark:|:white_check_mark:|

***Decennial Census ICE variables:***

|Name                 |Privileged                |Deprived                             |2010              |
|---------------------|--------------------------|-------------------------------------|------------------|
|Income               |\>\$75k                   |\<\$20k                              |:white_check_mark:|
|Race/ethnicity       |White non-Hispanic        |Black non-Hispanic                   |:white_check_mark:|
|Home ownership       |Owner-occupied unit       |Renter-occupied unit                 |:white_check_mark:|
|Income/race          |White non-Hispanic \>\$75k|Black alone \<\$20k                  |:white_check_mark:|
|Income/race/ethnicity|White non-Hispanic \>\$75k|\<\$20k \- White non-Hispanic \<\$20k|:white_check_mark:|
|Education            |Bachelor's degree or more |Less than a high school degree       |:white_check_mark:|
|Language             |English only              |Spanish                              |:white_check_mark:|

## Funding

Sam Jaros is supported by the National Institute On Drug Abuse of the National Institutes of Health under Award Number F31DA057107. The content is solely the responsibility of the authors and does not necessarily represent the official views of the National Institutes of Health.
