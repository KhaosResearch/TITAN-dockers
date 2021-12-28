#########################
# Install the libraries #
#########################

lbs <- c("optparse", "plotly", "htmlwidgets", "dplyr", "stringr")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)

#######################
# Command line config #
#######################

option_list = list(
  make_option(
    c("--inputPrecipitation"),
    type = "character",
    default = NULL,
    help ="Precipitation file path",
    metavar = "character"
  ),
  make_option(
    c("--inputAnalysis"),
    type = "character",
    default = NULL,
    help = "Stations analysis file path",
    metavar = "character"
  ),
  make_option(
    c("--controlStation"),
    type = "character",
    default = NULL,
    help='A character string with the name of the control station to be analised.', 
    metavar = "character"
  ),
  make_option(
    c("--baseStation"),
    type = "character",
    default = NULL,
    help='A character string with the name of the base station to be used.', 
    metavar = "character"
  ),
  make_option(
    c("--delimiterPrecipitation"),
    type = "character",
    default = NULL,
    help='The delimiter of precipitation file.', 
    metavar = "character"
  ),
  make_option(
    c("--delimiterAnalysis"),
    type = "character",
    default = NULL,
    help='The delimiter of analysis stations file.', 
    metavar = "character"
  )
)

opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

#############
# Functions #
#############

readFile <- function (file, delimiter){
  if(is.null(file)){
    stop("File path is mandatory")
  }
  
  data <- read.csv(file, sep=delimiter)
  
  return(data)
}

calculateSum <- function(dataFrame){
  first_year <- dataFrame$DATE[1]
  first_year <- substr(first_year, 1, 4)
  last_year <- dataFrame$DATE[nrow(dataFrame)]
  last_year <- substr(last_year, 1, 4)
  total <- c()
  years <- c()
  for(i in first_year:last_year){
    year_information <- dataFrame %>% filter(dataFrame$DATE > paste(as.character(i), "-09-30", sep = "") & dataFrame$DATE < paste(as.character(i+1), "-10-01", sep = ""))
    records <- year_information[,1]
    suma <- sum(records)
    total <- rbind(total,suma)
    years <- rbind(years,i)
  }
  accumulated <- cumsum(total)
  final_dataFrame <- data.frame(years,total,accumulated)
}

#############
# Variables #
#############

csv_data <- readFile(opt$inputPrecipitation, opt$delimiterPrecipitation)
csv_stations <- readFile(opt$inputAnalysis, opt$delimiterAnalysis)
control_station <- opt$controlStation
base_station <- opt$baseStation

baseStationInfo <- select(csv_data, base_station, DATE)
baseStationInfo <- na.omit(baseStationInfo)
controlStationInfo <- select(csv_data, control_station, DATE)
controlStationInfo <- na.omit(controlStationInfo)

controlStation <- calculateSum(controlStationInfo)
baseStation <- calculateSum(baseStationInfo)

stations <- merge(x = baseStation , y = controlStation, by = "years")

name = "data/Station_Comparison_"
name <- paste(name, control_station, sep = "")
name <- name <- paste(name, "_", sep = "")
name <- paste(name, base_station, sep = "")

base_info <- csv_stations[,base_station]
information <- "Control Station : "
information <- paste(information, control_station, sep = "")
information <- paste(information, "\nBase Station : ", sep = "")
information <- paste(information, base_station, sep = "")
information <- paste(information, "\nR2 : ", sep = "")
information <- paste(information, base_info[1], sep = "")
information <- paste(information, "\nSlope : ", sep = "")
information <- paste(information, base_info[2], sep = "")
information <- paste(information, "\nIntercept : ", sep = "")
information <- paste(information, base_info[3], sep = "")
information <- paste(information, "\nPair of data : ", sep = "")
information <- paste(information, base_info[4], sep = "")
titulo <- base_station
titulo <- paste(titulo, " vs. ", sep = "")
titulo <- paste(titulo, control_station, sep = "")

maxBaseControl <- c(tail(stations$accumulated.x, n=1), tail(stations$accumulated.y, n=1))
maximo <- max(maxBaseControl)
tituloX <- paste(control_station, " (mm)", sep = "")
tituloY <- paste(base_station, " (mm)", sep = "")
finalData <- data.frame(stations$accumulated.x, stations$accumulated.y)
regression <- stations %>% lm(accumulated.y ~ accumulated.x,.) %>% fitted.values()
graph <- plot_ly(finalData, x = ~ stations.accumulated.x, name = "Precipitation", y = ~ stations.accumulated.y, type = "scatter", mode = "markers") %>% add_trace(x = ~ stations.accumulated.x, y = regression, name = "Regression", mode = "lines") %>%
  layout(showlegend = F) %>%
  layout(title = titulo,
         xaxis = list(title = tituloX, range = list(0, maximo)),
         yaxis = list(title = tituloY, range = list(0, maximo)))
name_html <- paste(name, ".html", sep = "")
saveWidget(graph, name_html, title = titulo, selfcontained = TRUE) 