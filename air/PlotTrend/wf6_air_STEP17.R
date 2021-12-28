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

ipak(c("AeRobiology","tidyverse","optparse"))


#######################
# Command line config #
#######################
option_list = list(
  make_option(
    c("-i","--input"),
    type = "character",
    default = NULL,
    help ="Input file path",
    metavar = "character"
  ),
  make_option(
    c("--interpolation"),
    type="logical",
    default= TRUE,
    help='logical value specifying if the visualization shows the gaps in the inputs data
(interpolation = FALSE) or if an interpolation method is used for filling the
gaps (interpolation = TRUE). By default, interpolation = TRUE.'
    , metavar = "logical"
  ),
  make_option(
    c("--intMethod"),
    type="character",
    default= "lineal",
    help='A character string with the name of the interpolation method to be used.
The implemented methods that may be used are: "lineal", "movingmean",
"tseries" or "spline". By default, int.method = "lineal".'
    , metavar = "character"
  ),
  make_option(
    c("--exportPlot"),
    type="logical",
    default= TRUE ,
    help='A logical value specifying if a plot will be exported or not. If FALSE graphical
results will only be displayed in the active graphics window. If TRUE graphical
results will be displayed in the active graphics window and also one pdf/png file
will be saved within the plot_AeRobiology directory automatically created in the
working directory. By default, export.plot = TRUE.'
    , metavar = "logical"
  ),
  make_option(
    c("--exportFormat"),
    type="character",
    default= "pdf",
    help='A character string specifying the format selected to save the plot. The implemented
formats that may be used are: "pdf" or "png". By default, export.format = "pdf".'
    , metavar = "character"
  ),
  make_option(
    c("--exportResult"),
    type="logical",
    default= TRUE,
    help='A logical value. If export.result = TRUE, a table is exported with the extension
.xlsx, in the directory table_AeRobiology. By default it is FALSE.'
    , metavar = "logical"
  ),
  make_option(
    c("--method"),
    type="character",
    default= "percentage",
    help='A character string specifying the method applied to calculate the pollen season
and the main seasonal parameters. The implemented methods that can be used
are: "percentage", "logistic", "moving", "clinical" or "grains". By
default, method = "percentage" (perc = 95%).'
    , metavar = "character"
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
interpolation <- as.logical(opt$interpolation)
int.method <- opt$intMethod
export.plot <- as.logical(opt$exportPlot)
export.format <- opt$exportFormat
export.result <- opt$exportResult
method <- opt$method

#################
# End variables #
#################
########
# MAIN #
########

# open the file
#pdf("data/plot_trend.pdf") 

setwd("data")

plot_trend(
  data = data,
  interpolation = interpolation,
  int.method = int.method,
  export.plot = export.plot,
  export.format = export.format,
  export.result = export.result,
  method = method
)

f2z <- dir("plot_AeRobiology/trend_plots", full.names = TRUE)
zip(zipfile = 'trend_plots', files = f2z)
unlink("plot_AeRobiology", recursive = TRUE)
unlink("Rplots.pdf", recursive = TRUE)

