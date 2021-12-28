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
    c("-w","--window"),
    type = "integer",
    default=2,
    help = "A numeric (integer) value bigger or equal to 1",
    metavar="integer"
  ),
  make_option(
    c("-s", "--perc_miss"),
    type="integer",
    default=20,
    help="A numeric (integer) value between 0 and 100",
    metavar = "integer"
  ),
  make_option(
    c("-m", "--ps_method"),
    type="character",
    default="percentage",
    help="A character string specifying the method applied 
          to calculate the pollen season",
    metavar = "character"
    
  ),
  make_option(
    c("-p", "--perc"),
    type="integer",
    default=95,
    help="A numeric (integer) value between 0 and 100",
    metavar = "integer"
  ),
  make_option(
    c("-r", "--result"),
    type="character",
    default="plot",
    help="A character string specifying the format of the results 
          (table or plot)",
    metavar="character"
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
int.window <- as.numeric(opt$window)
perc.miss <- as.numeric(opt$perc_miss)
perc <- as.numeric(opt$perc)


library(AeRobiology)

library(tidyverse)

pdf("data/quality_control.pdf") 

qc <- quality_control(data = data,
                      int.window = int.window,
                      perc.miss = perc.miss,
                      ps.method = opt$ps_method,
                      perc = perc,
                      result = opt$result)


plot(qc)
dev.off()  

pg <- ggplot_build(qc)

write.csv(pg$plot$data, "data/quality_control.csv")