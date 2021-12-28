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
    c("--year"),
    type = "numeric",
    default = NULL,
    help="An integer value specifying the year to display. This is a mandatory argument",
    metavar = "numeric"
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
year <- opt$year


if(is.null(year)){
  stop("Year argument is mandatory")
}else{
  year <- as.numeric(year)
}

#################
# End variables #
#################
########
# MAIN #
#######
setwd("data")

colnames <- colnames(data)
pollens <- colnames[2:length(colnames)]

data2 <- data %>%
  mutate(years = format(data$date, "%Y")) %>%
  mutate(month = format(data$date, "%m"))%>%
  group_by(years)

data_by_year <- filter(data2 , years == year)

fig<- plot_ly(type = 'scatter' )

for (p in pollens){
  data3 <- data.frame(data_by_year["date"], data_by_year[p], data_by_year["years"], data_by_year["month"])
  data3[is.na(data3)] <- 0
  months <- c("January", "February", "March", "April", "May","June","July", "August", "September", "October", "November", "December")
  total_pollen <- aggregate(data3[p], by=list(month=data3$month), FUN=sum)
  names(total_pollen)[2] = "pollen"
  
  fig <- fig %>% add_trace(x=months, y=total_pollen$pollen, mode="lines", fill = 'tozeroy', name=p)
  fig <- fig %>% layout(xaxis = list(title = 'Month'),
                        yaxis = list(title = "Pollen's Count per Year"))

}


saveWidget(fig, "iplot_pollen.html", selfcontained = TRUE, libdir = NULL)

