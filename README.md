# Spatial Social Polarization Database

A database of pre-calculated spatial social polarization variables and the code used to calculate them. The purpose of this database is to remove computational barriers which prevent the wider use of useful indices in health research. This database is designed to provide an auditable and reproducible source of indices data.

### Authors

-   Sam Jaros
-   Lisa Frueh
-   Dr. Hoda Abdel Magid
-   Dr. Gina Lovasi

### Available Data

Download tables of values contained within the folders listed here as a .csv file using the download button or you can use https to grab the files using the raw button. Files are named in the format `[index abbreviation]_[source abbreviation]_[source date]_[geographic level].csv`, for example `ice_acs_2010_county.csv` contains ICE values from the 2010 American Community Survey at the county level.

==**NOTE:**== When you import the data, make sure the GEOID is being imported as a character, not a number. It is important to preserve leading zeros like for `01001`, a ZCTA in Agwam, Massachusetts. Opening the data in a program like Microsoft Excel or importing the data with `read.csv()` in `R` may remove these leading zeroes. Instead, we suggest using a program like [Notepad++](https://notepad-plus-plus.org/) or `readr::read_csv()` in `R`.

## Index of the Concentration at the Extremes

The Index of Concentration at the Extremes (ICE), [developed by sociologist Douglas Massey](https://www.researchgate.net/publication/312987867_The_Prodigal_Paradigm_Returns_Ecology_Comes_Back_to_Sociology), compares the percent of population in an area that are in a 'privileged' group and the percent of a population in the same area that are in the 'deprived' group:

$`ICE_i = (A_i - P_i)/T_i`$\
Where $`A_i`$ is the number of people in an area $`i`$ that belong to the advantaged group, and $`P_i`$ is the number of people in the area that belong to the deprived group, and $`T_i`$ is the total number of people in area $`i`$. ICE values range from -1 (most concentrated deprivation) to +1 (most concentrated privilege).

ICE can be calculated for any definition of privilege and deprivation. For example, an ICE for income could compare wealthy to poor population, an ICE for race might compare Black to white population, and an ICE for race/ethnicity/income might compare the concentration of high-income non-Hispanic whites to low-income people of color. This flexibility makes ICE a highly versatile measure of segregation.

Based on the user's specifications, the code contained in `ICE > code > ice_machine.R` will use American Community Survey or Decennial Census data for the specified year at the specified geographic level to retrieve the specified variables and calculate the ICE.

### Available ICE indices

***ACS ICE variables:***

| Column      | Name                                                                                            | Privileged                  | Deprived                             |        2010        |         2011          |       2012-2020       |
|-------------|-------------------------------------------------------------------------------------------------|-----------------------------|--------------------------------------|:------------------:|:---------------------:|:---------------------:|
| GEOID       | [Geography identifier](www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html) |                             |                                      |   County & tract   | County, ZCTA, & tract | County, ZCTA, & tract |
| ICEincome   | Income                                                                                          | \>\$100k                    | \<\$25k                              | :white_check_mark: |  :white_check_mark:   |  :white_check_mark:   |
| ICEraceeth  | Race/ethnicity                                                                                  | White non-Hispanic          | Black non-Hispanic                   | :white_check_mark: |  :white_check_mark:   |  :white_check_mark:   |
| ICEhome     | Home ownership                                                                                  | Owner-occupied unit         | Renter-occupied unit                 | :white_check_mark: |  :white_check_mark:   |  :white_check_mark:   |
| ICEincwb    | Income/race                                                                                     | White alone \>\$100k        | Black alone \<\$25k                  | :white_check_mark: |  :white_check_mark:   |  :white_check_mark:   |
| ICEincwnh   | Income/race/ethnicity                                                                           | White non-Hispanic \>\$100k | \<\$25k except White non-Hispanic    | :white_check_mark: |  :white_check_mark:   |  :white_check_mark:   |
| ICEedu      | Education                                                                                       | Bachelor's degree or more   | Less than a high school degree       |        :x:         |          :x:          |  :white_check_mark:   |
| ICElanguage | Language                                                                                        | English only                | Spanish                              | :white_check_mark: |  :white_check_mark:   | :white_check_mark:\*  |

\*Note that the accessible language ACS variable group changes from B16001 to C16001 in 2016 as documented [here](https://www.census.gov/content/dam/Census/programs-surveys/acs/tech-doc/user-notes/2016_Language_User_Note.pdf).

***Decennial Census ICE variables:***

| Column      | Name                                                                                            | Privileged                 | Deprived                             |         2000          |
|-------------|-------------------------------------------------------------------------------------------------|----------------------------|--------------------------------------|:---------------------:|
| GEOID       | [Geography identifier](www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html) |                            |                                      | County, ZCTA, & tract |
| ICEincome   | Income                                                                                          | \>\$75k                    | \<\$20k                              |  :white_check_mark:   |
| ICEraceeth  | Race/ethnicity                                                                                  | White non-Hispanic         | Black non-Hispanic                   |  :white_check_mark:   |
| ICEhome     | Home ownership                                                                                  | Owner-occupied unit        | Renter-occupied unit                 |  :white_check_mark:   |
| ICEincwb    | Income/race                                                                                     | White alone \>\$75k        | Black alone \<\$20k                  |  :white_check_mark:   |
| ICEincwnh   | Income/race/ethnicity                                                                           | White non-Hispanic \>\$75k | \<\$20k except White non-Hispanic    |  :white_check_mark:   |
| ICEedu      | Education                                                                                       | Bachelor's degree or more  | Less than a high school degree       |  :white_check_mark:   |
| ICElanguage | Language                                                                                        | English only               | Spanish                              |  :white_check_mark:   |

### Defining your own ICE values

The `ice_machine.R` code can be run using the `make_ice()` function that requires the user to specify the ICE formulas to be used, the geographic level of interest, the census survey to look for the variables in, and the survey year to use. A call to the function may look like:

```         
make_ice(formulas = data.frame("ice_measure"="ICEhome",
                               "privileged"="B03002_003",
                               "deprived"="B03002_004",
                               "total"="B03002_001"),
         geography = "county",
         survey = "acs",
         year = 2010)
```

The `make_ice()` function in `ice_machine.R` accepts a data frame with the following named columns:

`ice_measure`

:   The name for this ICE column in the returned data set

`privileged`

:   A math formula of census variables defining the privileged group

`deprived`

:   A math formula of census variables defining the deprived group

`total`

:   A math formula of census variables defining the total that the privileged and deprived groups belong to
