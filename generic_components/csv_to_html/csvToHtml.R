# Install (and load) kableExtra library

lbs <- c("kableExtra", "optparse")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)

# Read command line arguments

option_list = list(
  make_option(
    c("-i", "--input"), 
    type = "character",
    default = NA,
    help = "Dataset file",
  ),
  make_option(
    c("--delimiter"),
    type = "character",
    default=NULL,
    help = "Delimiter with which the csv is to be saved.",
    metavar = "character"
  )
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)


# Extract data frame from input file

csv_data <- read.table(opt$input, sep = opt$delimiter, check.names=FALSE, header=TRUE)


# Export the data frame to an html file

options(knitr.kable.NA = '')
kable(csv_data, "html", escape = F, align = "c", ) %>%
  kable_paper("striped", full_width = F, html_font = "American Typewriter") %>%
  save_kable(file = "data/dataFrame.html")