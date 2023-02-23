#SBS96 matrix downsampling code as function
#Ellie Dunstone, 2023


## Params: 

#mutation matrix - sbs96 mutation matrix or dataframe in 'SigProfiler' format (see https://github.com/AlexandrovLab/SigProfilerExtractor). The first column should list the 96 mutation types, with the remaining columns corresponding to the raw mutation counts for each sample.

#ds_thresh - this function will calculate the threshold for number of mutation calls above which to downsample your samples. However, if you wish to override this calculation and use your own threshold, you can specify it here.


## Returns:
#your downsampled mutation matrix 
#In future would also like to add returning: ds_thresh value calculated, and boxplots and histograms of mutation count distribution before and after downsampling

## Usage:

# sbs96_downsample(og_matrix) - downsamples samples from the matrix that are above threshold calculated based on the distribution of your data
# sbs96_downsample(og_matrix, ds_thresh = 5000) - downsamples samples from the matrix that are above 5000 total mutations

#######

#Assign sbs_downsample function

sbs96_downsample <- function(mutation_matrix, ds_thresh=NULL) {
  
  #calculate raw mutation totals per sample
  raw_muts_total <- as.data.frame(colSums(mutation_matrix[,-1]))
  raw_muts_total <- as.data.frame(cbind(sample = rownames(raw_muts_total), total_muts = raw_muts_total[,1]))
  raw_muts_total[,2] <- as.numeric(raw_muts_total[,2])
  
  #calculate downsampling threshold if not provided
  if (is.null(ds_thresh)) {
    quartiles <- quantile(raw_muts_total$total_muts) #calculate quartiles and min/max of the data
    thresh <- quartiles[4] + 1.5 * (quartiles[4] - quartiles[2])
    print(paste0("The suggested threshold for downsampling is ", thresh))
  } else {
    thresh <- ds_thresh #if threshold provided manually, assign
  }
  
  #identify samples above threshold
  above_thresh <- filter(raw_muts_total, total_muts > thresh)
  
  print(paste0("There are ", nrow(above_thresh), " samples to be downsampled, with mutation counts between ", min(above_thresh$total_muts), " and ", max(above_thresh$total_muts)))
  
  #calculate downsampling factors
  above_thresh <- mutate(above_thresh, ds_factor = thresh/total_muts)
  
  #init downsampled matrix
  ds_matrix <- mutation_matrix[,1]
  
  #downsample selected samples
  for (i in 2:ncol(mutation_matrix)) { 
    if (colnames(mutation_matrix)[i] %in% above_thresh$sample) {
      print(paste0("Downsampling sample ", colnames(mutation_matrix)[i], "..."))
      ds_matrix[,i] <- round(mutation_matrix[,i]*above_thresh$ds_factor[above_thresh$sample==colnames(mutation_matrix)[i]], 0)
    } else {
      ds_matrix[,i] <- mutation_matrix[,i]
    }
  }
  
  #return the downsampled matrix
  return(ds_matrix)
}




