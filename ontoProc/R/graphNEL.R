#' obtain graphNEL from ontology_plot instance of ontologyPlot
#' @import graph
#' @import Rgraphviz
#' @importFrom ontologyPlot onto_plot
#' @param x instance of S3 class ontology_plot
#' @return instance of S4 graphNEL class
#' @examples
#' requireNamespace("Rgraphviz")
#' requireNamespace("graph")
#' cl = getOnto("cellOnto")
#' cl3k = c("CL:0000492", "CL:0001054", "CL:0000236", "CL:0000625",
#'    "CL:0000576", "CL:0000623", "CL:0000451", "CL:0000556")
#' p3k = ontologyPlot::onto_plot(cl, cl3k)
#' gnel = make_graphNEL_from_ontology_plot(p3k)
#' gnel = improveNodes(gnel, cl)
#' graph::graph.par(list(nodes=list(shape="plaintext", cex=.8)))
#' gnel = Rgraphviz::layoutGraph(gnel)
#' Rgraphviz::renderGraph(gnel)
#' @export
make_graphNEL_from_ontology_plot <- function(x) {
        ont_graph <- new(
                "graphAM", 
                adjMat=x[["adjacency_matrix"]], 
                edgemode="directed"
        )   
        as(ont_graph, "graphNEL")
}

#' inject linefeeds for node names for graph, with textual
#' annotation from ontology 
#' @param g graphNEL instance
#' @param ont instance of ontology from ontologyIndex
#' @param width integer(1) maximum line width for wrapping term names,
#'   defaults to 15
#' @return graphNEL with node names replaced by wrapped label strings
#' @details
#' Term names are wrapped using \code{\link[base]{strwrap}} so that long
#' ontological labels are broken at word boundaries rather than truncated or
#' placed on a single overflowing line.  The ontology identifier (e.g.
#' \code{CL:0000492}) is appended below the wrapped name.
#' @export
improveNodes = function(g, ont, width = 15) {
  raw <- ont$name[nodes(g)]
  wrapped <- vapply(raw, function(s)
    paste(strwrap(s, width = width), collapse = "\n"),
    character(1))
  nn <- paste(wrapped, nodes(g), sep = "\n")
  nodes(g) <- nn
  g
}

#' high-level use of graph/Rgraphviz for rendering ontology relations
#' @param ont instance of ontology from ontologyIndex
#' @param terms2use character vector
#' @param cex numeric(1) defaults to .8, supplied to Rgraphviz::graph.par
#' @param width integer(1) maximum line width for wrapping term names,
#'   passed to \code{\link{improveNodes}}, defaults to 15
#' @param ... passed to onto_plot of ontologyPlot
#' @return graphNEL instance (invisibly)
#' @examples
#' cl = getOnto("cellOnto")
#' cl3k = c("CL:0000492", "CL:0001054", "CL:0000236", "CL:0000625",
#'    "CL:0000576", "CL:0000623", "CL:0000451", "CL:0000556")
#' onto_plot2(cl, cl3k)
#' @export
onto_plot2 = function(ont, terms2use, cex = 0.8, width = 15, ...) {
  pl = ontologyPlot::onto_plot(ont, terms2use, ...)
  gnel = make_graphNEL_from_ontology_plot(pl)
  gnel = improveNodes(gnel, ont, width = width)
  graph.par(list(nodes=list(shape="plaintext", cex=cex)))
  gnel = layoutGraph(gnel)
  renderGraph(gnel)
  invisible(gnel)
}

#' ggraph-based rendering of ontology relations using ggplot2 idioms
#'
#' @description
#' \code{onto_plot3} is an alternative to \code{\link{onto_plot2}} that uses
#' the \pkg{ggraph} and \pkg{tidygraph} packages to produce a
#' \code{\link[ggplot2]{ggplot}} object.  Because the result is a standard
#' ggplot, users can apply any ggplot2 layer, scale, or theme on top of the
#' returned value.
#'
#' @param ont instance of ontology from \pkg{ontologyIndex}
#' @param terms2use character vector of ontology term identifiers to display
#' @param width integer(1) maximum character width for wrapping node labels;
#'   passed to \code{\link[base]{strwrap}}; defaults to 20
#' @param layout character(1) \pkg{ggraph} layout algorithm to use; defaults
#'   to \code{"sugiyama"} which produces a top-down DAG layout suitable for
#'   hierarchical ontologies.  Any layout supported by \pkg{igraph} or
#'   \pkg{ggraph} can be supplied.
#' @param label_size numeric(1) base font size for node labels; defaults to 3
#' @param ... additional arguments passed to
#'   \code{\link[ontologyPlot]{onto_plot}}
#' @return A \code{ggplot} object.  The plot is also printed as a side-effect
#'   so that it appears in interactive sessions; assign the return value to
#'   suppress automatic printing.
#' @details
#' Nodes are rendered as labelled rectangles (\code{geom_node_label}) whose
#' bounding boxes automatically expand to accommodate multi-line text.  Edges
#' are drawn as directed arrows.  Nodes are coloured by their depth in the
#' DAG (distance from the root node set), providing an at-a-glance view of
#' the ontological hierarchy.
#'
#' Long term names are wrapped at \code{width} characters using
#' \code{\link[base]{strwrap}}, and the ontology identifier is printed below
#' the wrapped name.
#'
#' @seealso \code{\link{onto_plot2}} for the classic Rgraphviz-based renderer,
#'   \code{\link{improveNodes}} for the underlying label-wrapping helper.
#' @importFrom ontologyPlot onto_plot
#' @importFrom ggraph ggraph geom_edge_link geom_node_label theme_graph circle
#' @importFrom tidygraph as_tbl_graph
#' @importFrom igraph graph_from_adjacency_matrix distances vertex_attr
#' @importFrom ggplot2 aes arrow unit scale_fill_viridis_c labs
#' @examples
#' if (requireNamespace("ggraph", quietly = TRUE) &&
#'     requireNamespace("tidygraph", quietly = TRUE)) {
#'   cl = getOnto("cellOnto")
#'   cl3k = c("CL:0000492", "CL:0001054", "CL:0000236", "CL:0000625",
#'      "CL:0000576", "CL:0000623", "CL:0000451", "CL:0000556")
#'   p = onto_plot3(cl, cl3k)
#'   # further customise:
#'   # p + ggplot2::theme(legend.position = "bottom")
#' }
#' @export
onto_plot3 = function(ont, terms2use, width = 20, layout = "sugiyama",
                      label_size = 3, ...) {
  if (!requireNamespace("ggraph", quietly = TRUE))
    stop("Package 'ggraph' is required for onto_plot3. ",
         "Install with: install.packages('ggraph')")
  if (!requireNamespace("tidygraph", quietly = TRUE))
    stop("Package 'tidygraph' is required for onto_plot3. ",
         "Install with: install.packages('tidygraph')")

  # Build the ontology_plot and extract adjacency matrix
  pl <- ontologyPlot::onto_plot(ont, terms2use, ...)
  adj <- pl[["adjacency_matrix"]]
  term_ids <- rownames(adj)

  # Wrap term names at 'width' characters
  raw_names <- ont$name[term_ids]
  raw_names[is.na(raw_names)] <- term_ids[is.na(raw_names)]
  wrapped <- vapply(seq_along(raw_names), function(i) {
    paste(c(strwrap(raw_names[[i]], width = width), term_ids[i]),
          collapse = "\n")
  }, character(1))

  # Convert adjacency matrix to igraph, then to tbl_graph
  ig <- igraph::graph_from_adjacency_matrix(adj, mode = "directed",
                                            diag = FALSE)
  igraph::vertex_attr(ig, "label") <- wrapped
  igraph::vertex_attr(ig, "term_id") <- term_ids

  # Compute depth from source nodes (nodes with no incoming edges)
  in_deg <- igraph::degree(ig, mode = "in")
  roots <- which(in_deg == 0)
  if (length(roots) == 0L) roots <- 1L   # fallback for cyclic subgraphs
  dist_mat <- igraph::distances(ig, v = roots, to = igraph::V(ig),
                                mode = "out")
  depth <- apply(dist_mat, 2, function(d) {
    finite_d <- d[is.finite(d)]
    if (length(finite_d) == 0L) 0L else min(finite_d)
  })
  igraph::vertex_attr(ig, "depth") <- as.numeric(depth)

  tg <- tidygraph::as_tbl_graph(ig)

  p <- ggraph::ggraph(tg, layout = layout) +
    ggraph::geom_edge_link(
      arrow = ggplot2::arrow(length = ggplot2::unit(3, "mm"),
                             type = "closed"),
      end_cap = ggraph::circle(5, "mm"),
      colour = "grey50"
    ) +
    ggraph::geom_node_label(
      ggplot2::aes(label = label, fill = depth),
      size = label_size,
      lineheight = 0.85,
      label.padding = ggplot2::unit(0.3, "lines")
    ) +
    ggplot2::scale_fill_viridis_c(
      name = "Depth",
      option = "plasma",
      direction = -1,
      alpha = 0.7
    ) +
    ggplot2::labs(
      caption = paste("Layout:", layout)
    ) +
    ggraph::theme_graph(base_family = "sans")

  print(p)
  invisible(p)
}
