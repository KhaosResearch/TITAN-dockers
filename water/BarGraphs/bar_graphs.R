#########################
# Install the libraries #
#########################

lbs <- c("optparse", "htmlwidgets", "plotly")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)

#######################
# Command line config #
#######################

option_list = list(
  make_option(
    c("--inputData"),
    type = "character",
    default = NULL,
    help ="Path of data input file",
    metavar = "character"
  ),
  make_option(
    c("--inputHomogeneity"),
    type = "character",
    default = NULL,
    help = "Path of homogeneity tests file",
    metavar = "character"
  ),
  make_option(
    c("--test"),
    type = "character",
    default = NULL,
    help='A character string with the name of the homogeneity test to be used.', 
    metavar = "character"
  ),
  make_option(
    c("--delimiterData"),
    type = "character",
    default = NULL,
    help='The delimiter of data file.', 
    metavar = "character"
  ),
  make_option(
    c("--delimiterHomogeneity"),
    type = "character",
    default = NULL,
    help='The delimiter of homogeneity file.', 
    metavar = "character"
  ), 
  make_option(
    c("--dataType"),
    type = "character",
    default = NULL,
    help='A character indicating if data is related to precipitation of temperature. "Temperature" for temperature and "Precipitation" for precipitation.', 
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
  
  data <- read.csv(file, sep=delimiter, check.names=FALSE)
  
  return(data)
}

#############
# Variables #
#############

csv_data <- readFile(opt$inputData, opt$delimiterData)
csv_test <- readFile(opt$inputHomogeneity, opt$delimiterHomogeneity)
test <- opt$test
dataType <- opt$dataType

# Enter a column with the indexes

indexes <- c(1:nrow(csv_data))
csv_data <- cbind(csv_data,indexes)

# Select the change point location and the corresponding index

index_date <- csv_test[test][2,]
index_cut <- csv_data[csv_data$DATE == index_date,][,3]

# Make the plot 

information <- "Homogeneity : "
information <- paste(information, csv_test[test][1,], sep = "")
information <- paste(information, "\nP-value : ", sep = "")
information <- paste(information, csv_test[test][3,], sep = "")
information <- paste(information, "\nMaximum test Statistics : ", sep = "")
information <- paste(information, csv_test[test][4,], sep = "")
cadena <- csv_test[test][5,]
mu1_mu2 <- unlist(strsplit(gsub("[\\(\\)]", "", regmatches(cadena, gregexpr("\\(.*?\\)", cadena))[[1]]), ", "))
mu1 <- substr(mu1_mu2[1],5,9)
mu2 <- substr(mu1_mu2[2],5,9)
legend_mu1 <- paste("mu1 = ", mu1, sep = "")
legend_mu2 <- paste("mu2 = ", mu2, sep = "")
name <- "data/Homogeneity_Plot_"
name <- paste(name, gsub(" ", "_", test), sep = "")

hor_segment1 <- data.frame(
    x = c(0), xend = c(index_cut),
    y = c(as.numeric(mu1)), yend = c(as.numeric(mu1)))

hor_segment2 <- data.frame(
    x = c(index_cut), xend = c(nrow(csv_data)),
    y = c(as.numeric(mu2)), yend = c(as.numeric(mu2)))

ver_segment <- data.frame(
  x = c(index_cut), xend = c(index_cut),
  y = c(0), yend = c(max(csv_data[,2])))

if(dataType == "Precipitation") {
  nameGraphic = "Precipitation"
  titleGraphic = "PRECIPITATION"
  labelX = "Precipitation (mm)"
} else {
  nameGraphic = "Temperature"
  titleGraphic = "TEMPERATURE"
  labelX = "Temperature (ºC)"
}

graph <- plot_ly(csv_data, x = ~indexes, y = ~csv_data[,2], name = nameGraphic, type = 'bar', colors = c("blue"))%>%
    add_segments(
    data = hor_segment1, name = legend_mu1, x = ~x, xend = ~xend,
    y = ~y, yend = ~yend, color = I("red"), size = I(4), line = list(dash = "dash"))%>%
    add_segments(
    data = hor_segment2, name = legend_mu2, x = ~x, xend = ~xend,
    y = ~y, yend = ~yend, color = I("green"), size = I(4), line = list(dash = "dash"))%>%
    add_segments(
    data = ver_segment, name = "Change of homogeneity", x = ~x, xend = ~xend,
    y = ~y, yend = ~yend, color = I("orange"), size = I(4))%>%
    layout(title = titleGraphic,
         xaxis = list(title = 'Time (days)',
                      zeroline = TRUE),
         yaxis = list(title = labelX))%>%
    layout(showlegend = T) 

name_html <- paste(name, ".html", sep = "")
saveWidget(graph, name_html, title = titleGraphic, selfcontained = TRUE, libdir = NULL) 