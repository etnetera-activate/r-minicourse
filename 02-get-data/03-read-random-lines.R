#################################################################
#
# read random lines from large dataset and write to short dataset 
#
#################################################################

setwd("02-get-data/")

input <- "./webmaster-activate.csv"         #input file
output <- "./webmaster-activate-short.csv"  #output file

totalRows <- 100                            #how many lines are in input. Try wc -l in bash 
outputRows <- 10                            #how many rows shall we select

sel <- sample(1:totalRows, outputRows)      #generate random line numbers without repeating

try(file.remove(output)) #delete file if exists

for (i in 1:outputRows) { 
  #read each line using scan function
  line <- scan(input, what= character(), sep = "\n", skip=sel[i], nlines=1)
  #write to output
  write(line, output, append=TRUE) 
}

# now read filtered dataset and anlayze it
# ....

