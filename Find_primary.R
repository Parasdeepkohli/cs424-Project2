primary <- function(x) {
  
  maxval = x[1]
  maxind = 1
  
  for (i in 2:length(x)){
    if (x[i] > maxval){
      maxval <- x[i]
      maxind <- i
    } 
  }
  
  
  if (maxval == 0){
    label <- "None"
  }
  else{
  label <- ifelse(maxind == 1, "Coal",  
                   ifelse(maxind == 2, "Oil",
                          ifelse(maxind == 3, "Gas",
                                 ifelse(maxind == 4,"Nuclear",
                                    ifelse(maxind == 5,"Hydro",
                                           ifelse(maxind == 6, "Biomass",
                                                  ifelse(maxind == 7,"Wind",
                                                         ifelse(maxind == 8, "Solar",
                                                                ifelse(maxind == 9, "Geothermal", "Other"
                                        )))))))))
  }
  return(c(label, maxval))
}