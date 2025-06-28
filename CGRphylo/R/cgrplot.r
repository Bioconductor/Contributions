#' Chaos Game Representation (CGR) Coordinate Matrix
#'
#' Computes the CGR 2D coordinates for a DNA sequence without binning, for plotting purposes.
#'
#' @param seq_number Integer. The index of the sequence in `fasta_filtered` to process.
#' @param fasta_filtered A list of filtered DNA sequences.
#' @return A numeric matrix with two columns and one row per base. The columns represent the X and Y coordinates of each base in the CGR.
#'
#' @details This function generates the sequence of (x, y) coordinates used to construct a Chaos Game Representation (CGR) plot of a DNA sequence. It assumes a global object named \code{fasta_filtered} contains the DNA sequences.
#'
#' @examples
#' fasta_filtered <- fastafile_new(read.fasta("example.fasta"), 50)
#' cgrplot(1, fasta_filtered)
#'
#' @export
cgrplot <- function(seq_number,fasta_filtered)
{
  mat <- matrix(0, nchar(fasta_filtered[[seq_number]]), 2)  ## empty matrix


  x_base <- 1/2  ## start x value
  y_base <- 1/2  ## start y value

  for(i in 1:nchar(fasta_filtered[[seq_number]]))
  {
    base <- substr(fasta_filtered[[seq_number]], start = i, stop = i)

    if(base=='a'|| base=='A')
    {
      x_base=x_base/2
      y_base=y_base/2
    }else if(base=='t'||base=='T')
    {
      x_base=(x_base+1)/2
      y_base=y_base/2
    }else if(base=='g'||base=='G')
    {
      x_base=(x_base+1)/2
      y_base=(y_base+1)/2
    }  else if(base=='c'||base=='C')
    {
      x_base=x_base/2
      y_base=(y_base+1)/2
    }

    mat[i,1] <- x_base
    mat[i,2] <- y_base
  }
  return(mat)
}


