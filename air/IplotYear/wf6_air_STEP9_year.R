#Author : Daniel Doblas Jiménez
#Email : dandobjim@uma.es

##################
# load libraries #
##################

ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg,dependencies = TRUE, 
                     quiet = TRUE, 
                     repos = "https://cran.r-project.org/")
  sapply(pkg, 
         require, 
         character.only = TRUE)
}

ipak(c("tidyverse","plotly","optparse", "htmlwidgets"))


#######################
# Command line config #
#######################
option_list = list(
  make_option(
    c("-i","--input"),
    type = "character",
    default = NULL,
    help ="Inptu file path",
    metavar = "character"
  ),
  make_option(
    c("--pollen"),
    type = "character",
    default = NULL,
    help="A character string with the name of the particle to show. This character must
          match with the name of a column in the input database. This is a mandatory
          argument",
    metavar = "character"
  ),
  make_option(
    c("--delimiter"),
    type="character",
    default=",",
    help="Dataframe delimiter",
    metavar="character" 
  )
)

opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

###########################
# End command line config #
###########################

#############
# Functions #
#############
readFile <- function (file){
  if(is.null(file)){
    stop("File path is mandatory")
  }
  data <- read.csv(file, sep=opt$delimiter)
  data <- data[,c(2:ncol(data))]
  data$date <- as.Date(data$date)
  
  
  
  return(data)
}
#################
# End Functions #
#################

#############
# Variables #
#############
data <- readFile(opt$input)
pollen <- opt$pollen

if(is.null(pollen)){
  stop("Pollen argument is mandatory")
}

#################
# End variables #
#################

########
# MAIN #
########

setwd("data")

data2 <- data %>% 
  mutate(year = format(data$date, "%Y")) %>%
  mutate(month = format(data$date, "%m")) %>%
  group_by(year)


unique_dates <- unique(data2$year)

fig <- plot_ly(type = 'scatter' )

for(y in unique_dates){
  data3 <- filter(data2, year==y)
  data3[is.na(data3)] <- 0
  months <- c("January", "February", "March", "April", "May","June","July", "August", "September", "October", "November", "December")
  total_pollen <- aggregate(data3[pollen], by=list(month=data3$month), FUN=sum)
  names (total_pollen)[2] = "pollen"
  
  fig <- fig %>% add_trace(x=months, y=total_pollen$pollen, mode="lines", fill = 'tozeroy', name=y)
  fig <- fig %>% layout(xaxis = list(title = 'Month'),
                        yaxis = list(title = "Pollen's Count per Year"))
  

}

saveWidget(fig, "iplot_year.html", selfcontained = TRUE)

