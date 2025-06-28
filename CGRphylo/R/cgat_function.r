#' Chaos Game Representation (CGR) Frequency Matrix
#'
#' Generates a CGR frequency matrix from a given DNA sequence using a specified k-mer size.
#'
#' @param k_mer Integer. The k-mer size used to define resolution (e.g., 6 for 4^6 bins).
#' @param seq_number Integer. The index of the sequence in `fasta_filtered` to process.
#' @param len_trim Integer. The number of bases to use from the start of the sequence.
#' @param fasta_filtered A list of filtered DNA sequences.
#'
#' @return A square numeric matrix of size sqrt(4^k_mer) x sqrt(4^k_mer) representing the frequency of k-mers at each CGR coordinate.
#'
#' @details This function uses a recursive approach to generate a 2D CGR matrix from DNA. It assumes that a global object named \code{fasta_filtered} is present and contains DNA sequences accessible by index.
#'
#' @examples
#' # Example assuming fasta_filtered is loaded:
#' # fasta_filtered <- list("ATCGTAGCTAAGCTAGCT")
#' # cgr_mat <- cgat(k_mer = 6, seq_number = 1, len_trim = 100)
#'
#' @export
#'
cgat <- function(k_mer, seq_number, len_trim, fasta_filtered)
{

matDim<- sqrt(4^k_mer)    ##freq matrix dimension
mat <- matrix(0, matDim, matDim)  ## empty matrix

x_base <- matDim/2  ## start x value
y_base <- matDim/2  ## start y value

for(i in 1:len_trim)
{
  base <- substr(fasta_filtered[[seq_number]], start = i, stop = i)

  if(base=='a'|| base=='A')
  {
    x_base=x_base/2
    y_base=y_base/2
  }else if(base=='t'||base=='T')
  {
    x_base=(x_base+matDim)/2
    y_base=y_base/2
  }else if(base=='g'||base=='G')
  {
    x_base=(x_base+matDim)/2
    y_base=(y_base+matDim)/2
  }  else if(base=='c'||base=='C')
  {
    x_base=x_base/2
    y_base=(y_base+matDim)/2
  }
  for(x in 1:matDim){
  for(y in 1:matDim){

        if(x_base > (x-1) & x_base < x){
          if(y_base> (y-1) & y_base< y){

                            mat[y,x] <- mat[y,x]+1
        }}}}}
  return(mat)
}


