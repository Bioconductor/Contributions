# Proposed implementation for vjcitn/ontoProc: adaptive ontology visualizations

This directory contains the files that should replace / be merged into the
corresponding paths in the [vjcitn/ontoProc](https://github.com/vjcitn/ontoProc)
repository to address the issue raised in Bioconductor/Contributions.

## What changed and why

### `R/graphNEL.R`  ← **replace existing file**

| Function | Change |
|---|---|
| `improveNodes` | Added `width = 15` parameter; replaced one-shot `sub(" ", "\n", ...)` with `strwrap()` + `paste(collapse = "\n")` so *all* word boundaries are wrapped, not just the first space |
| `onto_plot2` | Added `width = 15` parameter, forwarded to `improveNodes` |
| `onto_plot3` | **New function** — ggraph/tidygraph-based renderer returning a `ggplot` object |

#### Key properties of `onto_plot3`

* Uses `ggraph(layout = "sugiyama")` — a Sugiyama-style DAG layout that minimises edge crossings and arranges nodes top-to-bottom by hierarchy level.
* `geom_node_label` draws auto-sizing rectangular label boxes, so long ontological term definitions never overflow.
* Nodes are coloured by `depth` (distance from root), using a `viridis` colour scale.
* Returns a `ggplot` object, so users can add further ggplot2 layers, scales, or themes.
* Guards against missing `ggraph`/`tidygraph` with informative `stop()` messages rather than silent failures.

### `DESCRIPTION`  ← **replace existing file**

* Added `ggraph`, `tidygraph`, `ggplot2` to the `Suggests:` field (not `Imports:`) so the new `onto_plot3` function is optional — existing users of `onto_plot2` are unaffected.
* Bumped `Version` from `2.3.11` to `2.3.12`.

### `NAMESPACE.additions`  ← **merge into existing NAMESPACE**

Lists the new `export(onto_plot3)` and `importFrom(...)` directives that
`roxygen2` would generate when it processes the updated `graphNEL.R`.

### `man/improveNodes.Rd`  ← **replace existing file**

Documents the new `width` parameter and adds a `\details` section
explaining the `strwrap` approach.

### `man/onto_plot2.Rd`  ← **replace existing file**

Documents the new `width` parameter.

### `man/onto_plot3.Rd`  ← **new file**

Full roxygen-style documentation for `onto_plot3`.

### `vignettes/onto_plot3_section.Rmd`  ← **insert into `ontoProc.Rmd`**

Proposed new section for `vignettes/ontoProc.Rmd` demonstrating:
1. Basic `onto_plot3` call on the PBMC example.
2. Post-hoc ggplot2 customisation.
3. Using `onto_plot3` with the AEO ontology (long names use-case).
4. Switching layout algorithms.

## How to apply

```bash
# From the root of a local clone of vjcitn/ontoProc:
cp R/graphNEL.R <path-to-ontoProc>/R/graphNEL.R
cp DESCRIPTION <path-to-ontoProc>/DESCRIPTION
cp man/improveNodes.Rd <path-to-ontoProc>/man/improveNodes.Rd
cp man/onto_plot2.Rd   <path-to-ontoProc>/man/onto_plot2.Rd
cp man/onto_plot3.Rd   <path-to-ontoProc>/man/onto_plot3.Rd
# Then regenerate NAMESPACE with roxygen2:
Rscript -e "roxygen2::roxygenise()"
# And integrate the vignette section manually.
```
