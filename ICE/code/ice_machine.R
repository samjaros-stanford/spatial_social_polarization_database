library(tidycensus)
library(tidyverse)

# ↓↓↓ Use the bottom section to specify ICE variables ↓↓↓

# Make sure your Census API key is loaded into the R environment
if(is.na(Sys.getenv()["CENSUS_API_KEY"])){
  census_api_key(read_lines(here::here("census_api_key.txt")), install=T)
}

# Function to interact with tidycensus to get ACS data
# Accepts requested geography, census variable list, and year
# Returns census data in wide format
get_census_acs = function(geography, variables, year){
  # Different geographic levels have different caveats
  # These if statements are designed to handle some of the differences
  if(geography=="tract"){
    # Only states (no territories)
    states = unique(fips_codes$state_code[fips_codes$state_code<60])
    census_long = get_acs(geography="tract", state=states, variables=variables, year=year)
  } else if(geography=="zcta"){
    census_long = get_acs(geography="zcta", variables=variables, year=year) %>%
      # GEOID's provided by the census are 7-digit state + ZCTA codes
      mutate(GEOID = str_sub(GEOID, -5, -1))
  } else {
    # This can handle state or county
    census_long = get_acs(geography=geography, variables=variables, year=year)
  }
  # Flip data to wide format
  census_long %>%
    pivot_wider(id_cols=GEOID,
                names_from=variable,
                values_from=estimate,
                values_fill=NA_integer_)
}

# Function to interact with tidycensus to get decennial census data
# Accepts requested geography, census variable list, and year
# Returns census data in wide format
get_census_decennial = function(geography, variables, year){
  # Different geographic levels have different caveats
  # These if statements are designed to handle some of the differences
  if(geography=="tract"){
    # Only states (no territories)
    states = unique(fips_codes$state_code[fips_codes$state_code<60])
    census_long = get_decennial(geography="tract", state=states, variables=variables, year=year)
  } else if(geography=="zcta"){
    census_long = get_decennial(geography="zcta", variables=variables, year=year) %>%
      # GEOID's provided by the census are 7-digit state + ZCTA codes
      mutate(GEOID = str_sub(GEOID, -5, -1))
  } else {
    # This can handle state or county
    census_long = get_decennial(geography=geography, variables=variables, year=year)
  }
  # Flip data to wide
  census_long %>%
    pivot_wider(id_cols=GEOID,
                names_from=variable,
                values_from=value,
                values_fill=NA_integer_)
}

# Runner function to call the data gathering functions, calculate ice, and return the compiled data sets
make_ice = function(formulas, geography, survey, year){
  # Get needed variable list from the census as a vector
  # Get ICE formula as a string, assuming all variables are found
  working_formulas = formulas %>%
    mutate(needed_vars = str_split(paste(privileged, deprived, total, sep="&"), "[-+*/&]"),
           ice_formula = paste0("(",privileged,"-(",deprived,"))/",total))
  
  # Iterate over ICEs specified in the formulas data frame
  #   For saving the final ICE caluclations
  ice_values = data.frame()
  #   For saving any ICE names that fail
  failed_ice = c()
  for(i in 1:nrow(working_formulas)){
    # Wrapped in a try/catch to allow for invalid variables, geographies, or ICE formulas
    tryCatch({
      # Decide which function to send the specifications to (ACS vs decennial)
      if(survey=="acs"){
        this_ice = get_census_acs(geography, working_formulas[i,"needed_vars"][[1]], year)
      } else if(survey=="decennial"){
        this_ice = get_census_decennial(geography, working_formulas[i,"needed_vars"][[1]], year)
      }
      # Calculate ICE values using given formula
      this_ice[[working_formulas[i,"ice_measure"]]] = with(this_ice, eval(parse(text=working_formulas[i,"ice_formula"])))
      # If this is the first valid ICE calculated, set the result data frame (ice_values) to be the first column (GEOID) and last column (calculated ICE)
      # If it's not the first value, full join the previous calculated ICEs and the ICE that was just calculated
      if(ncol(ice_values)==0){
        ice_values=select(this_ice, 1, ncol(this_ice))
      } else {
        ice_values=full_join(ice_values, select(this_ice, 1, ncol(this_ice)), by="GEOID")
      }
    }, error=function(e){
      # If an error is encountered, catch the stop, notify the user, print the error, and add the ICE name to the failed_ice list
      message(paste0("Failed to calculate ", working_formulas[i,"ice_measure"], "\n", e))
      failed_ice <<- c(failed_ice, working_formulas[i, "ice_measure"])
    })
    # If none of the ICEs were calculated, return a message rather than the data frame
    # If at least one of the ICEs succeeded, iterate over failed ICEs and add an empty column to represent the failure
    if(ncol(ice_values)==0){
      return("All ICE formulas failed")
    } else {
      for(ice in failed_ice){
        ice_values[[ice]]=NA
      }
    }
  }
  # Return calculated ICEs
  return(ice_values)
}

##########################################
# USE THESE LINES TO RUN THE ICE MACHINE #
##########################################
# ACS
#   Specify your ICE formulas from a file or data frame (using ACS variable names)
ice_acs_formulas = read.csv("ICE/code/ice_acs_formulas.csv")
#   Specify your ACS parameters (geo = geographies vector, year = years vector)
acs_params = expand.grid(geo = c("county", "zcta", "tract"), year = c(2010, 2011, 2012))
#   Iterate through the parameters and save the datasets
for(i in 1:nrow(acs_params)){
  write.csv(make_ice(ice_acs_formulas, acs_params[i,"geo"], "acs", acs_params[i,"year"]), 
            file=paste0("ICE/ice_acs_",acs_params[i,"year"],"_",acs_params[i,"geo"],".csv"),
            row.names=F)
}

# Decennial census
#   Specify ICE formulas from a file or data frame (using decennial census variable names)
ice_dec_formulas = read.csv("ICE/code/ice_dec_formulas.csv")
#   Specify your decennial census parameteres (geo = geographies vector, year = years vector)
dec_params = expand.grid(geo = c("county", "zcta", "tract"), year = c(2000))
#   Iterate through the parameters and save the datasets
for(i in 1:nrow(dec_params)){
  write.csv(make_ice(ice_dec_formulas, dec_params[i,"geo"], "decennial", dec_params[i,"year"]),
            file=paste0("ICE/ice_dec_",dec_params[i,"year"],"_",dec_params[i,"geo"],".csv"),
            row.names=F)
}
