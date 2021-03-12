pos_only <- function(x){
  
  for (i in 1:length(x)) {
    if (x[i] < 0){x[i] <- 0}
  }
  return (x)
}
source(Find_primary.R)
source(Find_sources.R)

preprocess <- function(path){

  input_data <- read.csv(path)
  colnames(input_data)[1] <- "PSTATEABB"
  
  input_data <- subset(input_data, Coal != '') # Removed rows with empty values
  
  # Block to convert energy generation columns to numeric
  
    for (row in 1:nrow(input_data)){ # Remove commas
      
      input_data[row, 5:15] <- gsub(",", "", input_data[row, 5:15])
    
    }
    input_data[, 5:15] <- lapply(input_data[, 5:15], as.numeric) # Convert to numeric
    input_data[, 5:15] <- lapply(input_data[, 5:15], pos_only) # set all negative values to 0
  
  input_data$Other <- input_data$Other.fossil + input_data$Other.unknown # Merge other columns into super column
  input_data <- input_data[-c(14,15)] # Drop component other columns
  
  # Block to set named columns to factor
  
  input_data$PSTATEABB <- as.factor(input_data$PSTATEABB)
  
  # Block to add total columns
  
    input_data$Total_renew <- input_data$Hydro + input_data$Geothermal + input_data$Biomass + input_data$Solar + input_data$Wind
    input_data$Total_nonRenew <- input_data$Coal + input_data$Oil + input_data$Gas + input_data$Nuclear + input_data$Other
    input_data$Total <- input_data$Total_renew + input_data$Total_nonRenew
  
  # Block to add percent columns
    
    input_data$Percent_Coal <- (input_data$Coal / input_data$Total) * 100
    input_data$Percent_Oil <- (input_data$Oil / input_data$Total) * 100
    input_data$Percent_Gas <- (input_data$Gas / input_data$Total) * 100
    input_data$Percent_Nuclear <- (input_data$Nuclear / input_data$Total) * 100
    input_data$Percent_Hydro <- (input_data$Hydro / input_data$Total) * 100
    input_data$Percent_Biomass <- (input_data$Biomass / input_data$Total) * 100
    input_data$Percent_Wind <- (input_data$Wind / input_data$Total) * 100
    input_data$Percent_Solar <- (input_data$Solar / input_data$Total) * 100
    input_data$Percent_Geothermal <- (input_data$Geothermal / input_data$Total) * 100
    input_data$Percent_Other <- (input_data$Other / input_data$Total) * 100
    
    input_data$Percent_renew <- (input_data$Total_renew / input_data$Total) * 100
    input_data$Percent_nonRenew <- (input_data$Total_nonRenew / input_data$Total) * 100
    
  
    
 

  # Block to add primary and secondary energy source(s)
  
  input_data$PrimarySource <- rep(0, nrow(input_data))
  for (row in 1:nrow(input_data)){
    
    input_data[row, "PrimarySource"] <- primary(input_data[row, 5:14])

  }
  
  input_data$PrimarySource <- as.factor(input_data$PrimarySource)
  
  row.names(input_data) <- NULL  
  return(input_data)  
}