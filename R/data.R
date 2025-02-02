#' Jellyfisher example data
#'
#' Example data based on the following publication:
#' Lahtinen A, Lavikka K, Virtanen A, et al.
#' Evolutionary states and trajectories characterized by distinct pathways
#' stratify patients with ovarian high grade serous carcinoma.
#' \emph{Cancer Cell}. 2023;41(6):1103-1117.e12.
#' \doi{10.1016/j.ccell.2023.04.017}
#'
#' @name jellyfisher_example_tables
#' @docType data
#' @keywords datasets
#'
#' @format ## `jellyfisher_example_tables`
#' A named list of data frames containing the following tables:
#' \describe{
#'   \item{\code{samples}}{A data frame with sample data. Columns are:
#'   \describe{
#'   \item{sample}{specifies the unique identifier for each sample. (string)}
#'   \item{displayName}{allows for specifying a custom name for each sample. If the column is omitted, the `sample` column is used as the display name. (string, optional)}
#'   \item{rank}{specifies the position of each sample in the Jellyfish plot. For example, different stages of a disease can be ranked in chronological order: diagnosis (1), interval (2), and relapse (3). The zeroth rank is reserved for the root of the sample tree. Ranks can be any integer, and unused ranks are automatically excluded from the plot. If the `rank` column is (integer)}
#'   \item{parent}{identifies the parent sample for each entry. Samples without a specified parent are treated as children of an imaginary root sample. (string)}
#'   }
#'     }
#'     \item{\code{phylogeny}}{A data frame with phylogeny data. Columns are:
#'   \describe{
#'   \item{subclone}{specifies subclone IDs, which can be any string. (string)}
#'   \item{parent}{designates the parent subclone. The subclone without a parent is considered the root of the phylogeny. (string)}
#'   \item{color}{specifies the color for the subclone. If the column is omitted, colors will be generated automatically. (string, optional)}
#'   \item{branchLength}{specifies the length of the branch leading to the subclone. The length may be based on, for example, the number of unique mutations in the subclone. The branch length is shown in the Jellyfish plot's legend as a bar chart. It is also used when generating a phylogeny-aware color scheme. (number)}
#'   }
#'     }
#'     \item{\code{compositions}}{A data frame with subclonal compositions. Columns are:
#'   \describe{
#'   \item{sample}{specifies the sample ID. (string)}
#'   \item{subclone}{specifies the subclone ID. (string)}
#'   \item{clonalPrevalence}{specifies the clonal prevalence of the subclone in the sample. The clonal prevalence is the proportion of the subclone in the sample. The clonal prevalences in a sample must sum to 1. (number)}
#'   }
#' }
#'     \item{\code{ranks}}{An optional data frame with ranks. Columns are:
#'   \describe{
#'   \item{rank}{specifies the rank number. The zeroth rank is reserved for the inferred root of the sample tree. However, you are free to define a title for it. (integer)}
#'   \item{title}{specifies the title for the rank. (string)}
#'   }
#' }
#' }
#' @source <https://github.com/HautaniemiLab/jellyfish/tree/main/data>
NULL
