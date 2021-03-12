sources <- function(x){
  
  inds <- c()
  labels <-c(" ")
  c <- 1
  
  for (i in 1:length(x)){
    
    if (x[i] > 0){
      inds[c] <- i
      c <- c + 1
    }
  }
  
  inds <- inds[1:c]
  labels <- labels[1:c]
  
  if (c > 1){
    
    for (i in 1:c){
      
      labels[i] <- ifelse(inds[i] == 1, "Coal",  
                      ifelse(inds[i] == 2, "Oil",
                             ifelse(inds[i] == 3, "Gas",
                                    ifelse(inds[i] == 4,"Nuclear",
                                           ifelse(inds[i] == 5,"Hydro",
                                                  ifelse(inds[i] == 6, "Biomass",
                                                         ifelse(inds[i] == 7,"Wind",
                                                                ifelse(inds[i] == 8, "Solar",
                                                                       ifelse(inds[i] == 9, "Geothermal", "Other"
                                                                       )))))))))
    }
    
  }
  else{
    labels[1] <- "None"
  }
  return (labels[!is.na(labels)])
}