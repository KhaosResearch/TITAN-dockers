
##################
# load libraries #
##################

lbs <- c("optparse", "AeRobiology", "readxl", "tidyverse")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)


#######################
# Command line config #
#######################
option_list = list(
  make_option(
    c("-i", "--input"),
    type = "character",
    default = NULL,
    help = "Input file name",
    metavar = "character"
  ),
  make_option(
    c("--pollenType"),
    type= "character",
    default = NULL,
    help = "A character string specifying the name of the pollen type 
    which will be plotted. The name must be exactly the same that appears 
    in the column name.",
    metavar = "character"
  ),
  make_option(
    c("--year"),
    type = "integer",
    default = NULL,
    help = "A numeric (interger) value specifying the season to be plotted. 
    The season does not necessary fit a natural year.",
    metavar = "integer"
  ),
  make_option(
    c("--days"),
    type = "integer",
    default = 30,
    help = "A numeric (interger) specifying the number of days 
    beyond each side of the main pollen season that will be represented",
    metavar = "integer"
  ),
  make_option(
    c("--filCol"),
    type = "character",
    default = "turquoise4",
    help = "A character string specifying the name of the color to 
    fill the main pollen season (Galan et al., 2017) in the plot",
    metavar = "character"
  ),
  make_option(
    c("--axisname"),
    type = "character",
    default = "Pollen grains / m ^ 3",
    help = "A character string or an expression specifying the y 
    axis title of the plot",
    metavar = "character"
  ),
  make_option(
    c("--intMethod"),
    type = "character",
    default = "lineal",
    help = "A character string specifying the method selected to apply the 
    interpolation method in order to complete the pollen series. 
    The implemented methods that may be used are: 'lineal', 'movingmean', 
    'spline' or 'tseries'.",
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


########
# MAIN #
########

data <- readFile(opt$input)

if(is.null(opt$pollenType)){
  stop("Please, select a pollen type")
}

if(is.null(opt$year)){
  stop("Please, select a valid year")
}

pdf("data/plot_ps.pdf") 

plt_ps <- plot_ps(data = data,
                  pollen.type = opt$pollenType,
                  year = as.numeric(opt$year),
                  days = as.numeric(opt$days),
                  fill.col = opt$filCol,
                  int.method = opt$intMethod,
                  axisname = opt$axisname)

plot(plt_ps)
dev.off()  