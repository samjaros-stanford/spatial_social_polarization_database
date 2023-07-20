library(tidycensus)
library(tidyverse)

# Make sure your Census API key is loaded into the R environment
if(is.na(Sys.getenv()["CENSUS_API_KEY"])){
  census_api_key(read_lines(here::here("census_api_key.txt")), install=T)
}

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
  census_long %>%
    pivot_wider(id_cols=GEOID,
                names_from=variable,
                values_from=estimate,
                values_fill=NA_integer_)
}

make_ice = function(formulas, geography, year){
  working_formulas = formulas %>%
    mutate(needed_vars = str_split(paste(privileged, deprived, total, sep="&"), "[-+*/&]"),
           ice_formula = paste0("(",privileged,"-(",deprived,"))/",total))
  
  ice_values = data.frame()
  failed_ice = c()
  for(i in 1:nrow(working_formulas)){
    tryCatch({
      this_ice = get_census_acs(geography, working_formulas[i,"needed_vars"][[1]], year)
      this_ice[[working_formulas[i,"ice_measure"]]] = with(this_ice, eval(parse(text=working_formulas[i,"ice_formula"])))
      if(ncol(ice_values)==0){
        ice_values=select(this_ice, 1, ncol(this_ice))
      } else {
        ice_values=full_join(ice_values, select(this_ice, 1, ncol(this_ice)), by="GEOID")
      }
    }, error=function(e){
      message(paste0("Failed to retrieve census data for ", working_formulas[i,"ice_measure"], "\n", e))
      failed_ice <<- c(failed_ice, working_formulas[i, "ice_measure"])
    })
    if(ncol(ice_values)==0){
      return("All ICE formulas failed")
    } else {
      for(ice in failed_ice){
        ice_values[[ice]]=NA
      }
    }
  }
  return(ice_values)
}

ice_acs_formulas = read.csv("ICE/code/ice_formulas.csv")
acs_params = expand.grid(geo = c("county", "zcta", "tract"), year = c(2010, 2011, 2012))
for(i in 1:nrow(acs_params)){
  write.csv(make_ice(ice_acs_formulas, acs_params[i,"geo"], acs_params[i,"year"]), 
            file=paste0("ICE/ice_acs_",acs_params[i,"year"],"_",acs_params[i,"geo"],".csv"),
            row.names=F)
}

