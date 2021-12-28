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
    help ="Inptu file path",
    metavar = "character"
  ),
  make_option(
    c("--pollen"),
    type = "character",
    default = NULL,
    help = 'A character string with the name of the particle to show. This character must
match with the name of a column in the input database. This is a mandatory
argument.',
    metavar = "character"
  ),
  make_option(
    c("--mave"),
    type = "numeric",
    default = 1,
    help = 'An integer value specifying the order of the moving average applied to the
data. By default, mave = 1.',
    metavar = "numeric",
  ),
  make_option(
    c("--normalized"),
    type = "logical",
    default = TRUE,
    help = 'A logical value specifying if the visualization shows real pollen data (normalized = FALSE)
or the percentage of every day over the whole pollen season (normalized = TRUE).
By default, normalized = FALSE.',
    metavar = "logical",
  ),
  make_option(
    c("--interpolation"),
    type = "logical",
    default = TRUE ,
    help = 'A logical value specifying if the visualization shows the gaps in the inputs data
(interpolation = FALSE) or if an interpolation method is used for filling the
gaps (interpolation = TRUE). By default, interpolation = TRUE.',
    metavar = "logical",
  ),
  make_option(
    c("--intMethod"),
    type = "character",
    default = "lineal" ,
    help = 'A character string with the name of the interpolation method to be used.
The implemented methods that may be used are: "lineal", "movingmean",
"tseries" or "spline". By default, int.method = "lineal".',
    metavar = "character",
  ),
  make_option(
    c("--exportPlot"),
    type = "logical",
    default = TRUE ,
    help = 'A logical value specifying if a plot will be exported or not. If FALSE graphical
results will only be displayed in the active graphics window. If TRUE graphical
results will be displayed in the active graphics window and also one pdf/png file
will be saved within the plot_AeRobiology directory automatically created in the
working directory. By default, export.plot = FALSE.',
    metavar = "logical",
  ),
  make_option(
    c("--exportFormat"),
    type = "character",
    default = "pdf" ,
    help = 'A character string specifying the format selected to save the plot. The implemented
formats that may be used are: "pdf" or "png". By default, export.format = "pdf".',
    metavar = "character",
  ),
  make_option(
    c("--axisname"),
    type = "character",
    default = "Pollen grains / m3" ,
    help = 'A character string specifying the title of the y axis. By default, axisname = "Pollen grains / m3".',
    metavar = "character",
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
mave <- opt$mave
normalized <- opt$normalized
interpolation <- opt$interpolation
int.method <- opt$intMethod
export.plot <- opt$exportPlot
export.format <- opt$exportFormat
axisname <- opt$axisname

if(is.null(pollen)){
  stop("pollen variable is mandatory")
}
#################
# End variables #
#################
########
# MAIN #
########

# open the file
pdf("data/plot_summary.pdf") 

plot_summary(
  data = data,
  pollen = pollen,
  mave = mave,
  normalized = normalized,
  interpolation = interpolation,
  int.method = int.method,
  export.plot = export.plot,
  export.format = export.format,
  axisname = axisname
)

# close the file
dev.off()