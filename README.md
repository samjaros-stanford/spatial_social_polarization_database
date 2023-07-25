# Spatial Social Polarization Database: Index of Concentration at the Extremes (ICE)
A database of pre-calculated spatial social polarization variables and the code used to calculate them. 

## Background
The Index of Concentration at the Extremes (ICE), developed by sociologist Douglas Massey, compares the % of population in an area that are in a 'privileged' group and the % of a population in the same area that are in the 'deprived' group:

$`ICE_i = (A_i - P_i)/T_i `$     
Where $`A_i`$ is the number of people in an area $`i`$ that belong to the advantaged group, and $`P_i`$ is the number of people in the area that belong to the disadvantaged group, and $`T_i`$ is the total number of people in area $`i`$. ICE values range from -1 (most concentrated disadvantage) to +1 (most concentrated privilege). 

ICE can be calculated for any combination of privileged/disadvantaged: for example, ICE for income could compare wealthy to poor population, ICE for race might compare Black to white population, and ICE for race/ethnicity/income might compare the concentration of high-income non-Hispanic whites to low-income people of color. This makes ICE a highly versatile measure of segregation.

## About this Repository
