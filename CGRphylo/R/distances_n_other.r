#' Calculate Distance Between Two Matrices
#'
#' Computes the distance between two matrices using either Euclidean or Manhattan distance.
#'
#' @param matrixA Numeric matrix.
#' @param matrixB Numeric matrix of the same dimensions as matrixA.
#' @param distance_type Character. Either "Euclidean", "S_Euclidean", or "Manhattan".
#'
#' @examples
#' matA <- matrix(c(1, 2, 3, 4), nrow = 2)
#' matB <- matrix(c(2, 2, 4, 5), nrow = 2)
#'
#' # Calculate Euclidean distance
#' matrixDistance(matA, matB, distance_type = "Euclidean")
#'
#' # Calculate Squared Euclidean distance (no square root applied)
#' matrixDistance(matA, matB, distance_type = "S_Euclidean")
#'
#' # Calculate Manhattan distance
#' matrixDistance(matA, matB, distance_type = "Manhattan")
#' @return A numeric scalar distance between the two matrices.
#' @export

matrixDistance <- function( matrixA,   matrixB, distance_type='Euclidean')
{
  #print(paste("Applying",distance_type,"distance", sep=" "))
  distance <- 0
  for(i in 1:dim(matrixA)[1])
  {
    for(j in 1:dim(matrixA)[1])
    {
      if(distance_type =='Euclidean' || distance_type =='S_Euclidean' )
      {
        dist=(matrixA[i,j]-matrixB[i,j])^2

      }else   ##Manhattan
      {
        dist=abs(matrixA[i,j]-matrixB[i,j])

      }

      distance=distance+dist
    }
  }

  if(distance_type=='Euclidean')
  {
    distance <- sqrt(distance)
    return(distance)


  }else{
    #print("no square distance")
    return(distance)

  }
}


#' Create Metadata for DNA Sequences
#'
#' Generates metadata such as sequence length, base counts, and GC content, filtering sequences with too many 'n' bases.
#'
#' @param fastafile Named list of character DNA sequences.
#' @param N_filter Integer. Maximum allowed count of 'n' characters (default 50).
#'
#' @return A data.frame containing metadata for each filtered sequence.
#' @examples
#' # Example DNA sequences as a named list
#' fasta_list <- list(
#'   seq1 = "atgcgatgcatgc",
#'   seq2 = "atgnnncatggc",
#'   seq3 = "nnnnnnnnnnnnnnn"
#' )
#'
#' # Generate metadata using default N_filter = 50
#' meta_df <- create_meta(fasta_list)
#' print(meta_df)
#'
#' # Generate metadata using stricter N_filter
#' meta_strict <- create_meta(fasta_list, N_filter = 5)
#' print(meta_strict)
#'
#' @export
#
create_meta <- function(fastafile,  N_filter =50)
{
  #library(stringr) ##for str_count
  sequence <- names(fastafile) ##substr(names(fastafile),1,12)
  n_new <- 1
  meta <- data.frame(matrix(nrow = length(fastafile), ncol=7))
  fastafile_new <- list() #vector()
  sequence_new <- vector()

  for(n in 1:length(fastafile)) {

    if(stringr::str_count(fastafile[[n]], "n")<=N_filter){

      fastafile_new[[n_new]] <- fastafile[[n]]
      meta[n_new,1] <- nchar(fastafile[[n]])
      meta[n_new,2] <- stringr::str_count(fastafile[[n]], "n")
      meta[n_new,3] <- stringr::str_count(fastafile[[n]], "a")
      meta[n_new,4] <- stringr::str_count(fastafile[[n]], "g")
      meta[n_new,5] <- stringr::str_count(fastafile[[n]], "t")
      meta[n_new,6] <- stringr::str_count(fastafile[[n]], "c")
      meta[n_new,7] <-   (meta[n_new,4]+meta[n_new,6])/meta[n_new,1]*100
      sequence_new[n_new] <- sequence[n]
      # print(paste("processing sequence : ",sequence[n],"Total length of the sequence : ",nchar(fastafile[[n]]), sep=" "))
      n_new <- n_new+1

    }else{ print(paste("Sequnce",sequence[n]," is filetred"), sep = '\t')}
  }
  names(fastafile_new) <- sequence_new
  meta <- meta[!(is.na(meta$X1)),] ##as.data.frame(t(as.data.frame(length_n)))
  colnames(meta) <-c("length","n_base","a_base","g_base","t_base","c_base","GC_content")
  meta$name <- sequence_new
  row.names(meta) <- sequence_new
  return(meta)
}

#' Filter DNA Sequences by N Content
#'
#' Filters sequences based on the number of 'n' characters allowed.
#'
#' @param fastafile Named list of character DNA sequences.
#' @param N_filter Integer. Maximum allowed 'n' count (default 50).
#'
#' @examples
#' # Sample named list of DNA sequences
#' fasta_list <- list(
#'   seq1 = "atgcatgcatgc",
#'   seq2 = "atgcnnntgcat",
#'   seq3 = "nnnnnnnnnnnn"
#' )
#'
#' # Create metadata with default N_filter (50)
#' meta_df <- create_meta(fasta_list)
#' print(meta_df)
#'
#' # Create metadata with stricter N_filter (max 3 Ns)
#' meta_df_filtered <- create_meta(fasta_list, N_filter = 3)
#' print(meta_df_filtered)
#' @return A named list of filtered sequences.
#' @export

fastafile_new <- function(fastafile,  N_filter =50)
{
  #library(stringr) ##for str_count
  sequence <- names(fastafile) ##substr(names(fastafile),1,12)
  n_new <- 1
  fastafile_new <- list() #vector()
  sequence_new <- vector()
  for(n in 1:length(fastafile)) {

    if(stringr::str_count(fastafile[[n]], "n")<=N_filter){

      fastafile_new[[n_new]] <- fastafile[[n]]
      sequence_new[n_new] <- sequence[n]
      n_new <- n_new+1

    }
  }
  names(fastafile_new) <- sequence_new
  return(fastafile_new)
}

#' Save Distance Matrix in MEGA Format
#'
#' Writes a pairwise distance matrix in MEGA-compatible lower triangular format.
#'
#' @param Mega_file_name Output file name (string).
#' @param distance Matrix of pairwise distances.
#'
#' @examples
#' # Create a sample 3x3 distance matrix with row and column names
#' dist_matrix <- matrix(c(
#'   0, 1.2, 2.3,
#'   1.2, 0, 1.5,
#'   2.3, 1.5, 0
#' ), nrow = 3, byrow = TRUE)
#' colnames(dist_matrix) <- rownames(dist_matrix) <- c("seq1", "seq2", "seq3")
#'
#' # Save the distance matrix in MEGA format to a temp file
#' tmp_file <- tempfile(fileext = ".meg")
#' saveMegaDistance(tmp_file, dist_matrix)
#'
#' # Check file contents (optional)
#' cat(readLines(tmp_file), sep = "\n")
#'
#' @return None. Writes a file to disk.
#' @importFrom utils write.table
#' @export

saveMegaDistance <- function(Mega_file_name, distance)
{
sequence_names <- colnames(distance)
dist_mega <- distance
dist_mega[upper.tri(dist_mega,diag=TRUE)] <- NA  #lower.tri

dist_mega <- sapply(as.data.frame(dist_mega), as.character)
dist_mega[is.na(dist_mega)] <- " "

lin1 <- paste0("#mega","\n","!Title: Concatenated Files;", "\n","!Format DataType=Distance DataFormat=LowerLeft;","\n", sep = '')
write.table(lin1,Mega_file_name, col.names = FALSE, row.names = FALSE,quote = FALSE)
#write.table(paste('#',names1$V1,names$V2,names$V3, sep = ''),file_name, sep="\t",append = TRUE, col.names = FALSE, row.names = FALSE,quote = FALSE)
write.table(paste('#',sequence_names, sep = ''),Mega_file_name, sep="\t",append = TRUE, col.names = FALSE, row.names = FALSE,quote = FALSE)
write.table("\n",Mega_file_name, sep="\t",append = TRUE, col.names = FALSE, row.names = FALSE,quote = FALSE)
write.table(dist_mega,Mega_file_name, sep="\t", append = TRUE,col.names = FALSE, row.names = FALSE, quote = FALSE)
}

#' Save Distance Matrix in PHYLIP Format
#'
#' Writes a pairwise distance matrix in PHYLIP format, relaxed or strict.
#'
#' @param PhylipFile_name Output file name (string).
#' @param distance Matrix of pairwise distances.
#' @param mode Character. Either "relaxed" (default) or any other string for strict format.
#'
#' @return None. Writes a file to disk.
#' @importFrom utils write.table
#' @examples
#' # Create a sample 3x3 distance matrix with row and column names
#' dist_matrix <- matrix(c(
#'   0, 1.2, 2.3,
#'   1.2, 0, 1.5,
#'   2.3, 1.5, 0
#' ), nrow = 3, byrow = TRUE)
#' colnames(dist_matrix) <- rownames(dist_matrix) <- c("seq1", "seq2", "seq3")
#'
#' # Save the distance matrix in PHYLIP relaxed format to a temp file
#' tmp_file <- tempfile(fileext = ".phy")
#' savePhylipDistance(tmp_file, dist_matrix, mode = "relaxed")
#'
#' # Check file contents (optional)
#' cat(readLines(tmp_file), sep = "\n")
#'
#' @export
savePhylipDistance <- function(PhylipFile_name, distance , mode='relaxed')
{
  sequence_names <- colnames(distance)
  dist_phylip <- distance
  dist_phylip[upper.tri(dist_phylip,diag=TRUE)] <- NA  #lower.tri

  dist_phylip <- sapply(as.data.frame(dist_phylip), as.character)
  dist_phylip[is.na(dist_phylip)] <- " "
  if(mode=='relaxed'){
  rownames(dist_phylip) <-   substr(sequence_names,1,10)}else{ rownames(dist_phylip) <-   substr(sequence_names,1,250)}

  write.table(length(sequence_names),PhylipFile_name, col.names = FALSE, row.names = FALSE,quote = FALSE)
  write.table(dist_phylip,PhylipFile_name, sep=" ", append = TRUE,col.names = FALSE, row.names = TRUE, quote = FALSE)
}
