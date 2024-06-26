% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connect_hub.R, R/connect_model_output.R
\name{connect_hub}
\alias{connect_hub}
\alias{connect_model_output}
\title{Connect to model output data.}
\usage{
connect_hub(
  hub_path,
  file_format = c("csv", "parquet", "arrow"),
  output_type_id_datatype = c("auto", "character", "double", "integer", "logical",
    "Date"),
  partitions = list(model_id = arrow::utf8())
)

connect_model_output(
  model_output_dir,
  file_format = c("csv", "parquet", "arrow"),
  partition_names = "model_id",
  schema = NULL
)
}
\arguments{
\item{hub_path}{Either a character string path to a local Modeling Hub directory
or an object of class \verb{<SubTreeFileSystem>} created using functions \code{\link[=s3_bucket]{s3_bucket()}}
or \code{\link[=gs_bucket]{gs_bucket()}} by providing a string S3 or GCS bucket name or path to a
Modeling Hub directory stored in the cloud.
For more details consult the
\href{https://arrow.apache.org/docs/r/articles/fs.html}{Using cloud storage (S3, GCS)}
in the \code{arrow} package.
The hub must be fully configured with valid \code{admin.json} and \code{tasks.json}
files within the \code{hub-config} directory.}

\item{file_format}{The file format model output files are stored in.
For connection to a fully configured hub, accessed through \code{hub_path},
\code{file_format} is inferred from the hub's \code{file_format} configuration in
\code{admin.json} and is ignored by default.
If supplied, it will override hub configuration setting. Multiple formats can
be supplied to \code{connect_hub} but only a single file format can be supplied to \code{connect_mod_out}.}

\item{output_type_id_datatype}{character string. One of \code{"auto"}, \code{"character"},
\code{"double"}, \code{"integer"}, \code{"logical"}, \code{"Date"}. Defaults to \code{"auto"} indicating
that \code{output_type_id} will be determined automatically from the \code{tasks.json}
config file. Other data type values can be used to override automatic determination.
Note that attempting to coerce \code{output_type_id} to a data type that is not possible
(e.g. trying to coerce to \code{"double"} when the data contains \code{"character"} values)
will likely result in an error or potentially unexpected behaviour so use with
care.}

\item{partitions}{a named list specifying the arrow data types of any
partitioning column.}

\item{model_output_dir}{Either a character string path to a local directory
containing model output data
or an object of class \verb{<SubTreeFileSystem>} created using functions \code{\link[=s3_bucket]{s3_bucket()}}
or \code{\link[=gs_bucket]{gs_bucket()}} by providing a string S3 or GCS bucket name or path to a
directory containing model output data stored in the cloud.
For more details consult the
\href{https://arrow.apache.org/docs/r/articles/fs.html}{Using cloud storage (S3, GCS)}
in the \code{arrow} package.}

\item{partition_names}{character vector that defines the field names to which
recursive directory names correspond to. Defaults to a single \code{model_id} field
which reflects the standard expected structure of a \code{model-output} directory.}

\item{schema}{An \link[arrow:Schema-class]{arrow::Schema} object for the Dataset.
If NULL (the default), the schema will be inferred from the data sources.}
}
\value{
\itemize{
\item \code{connect_hub} returns an S3 object of class \verb{<hub_connection>}.
\item \code{connect_mod_out} returns an S3 object of class \verb{<mod_out_connection>}.
}

Both objects are connected to the data in the model-output directory via an
Apache arrow \code{FileSystemDataset} connection.
The connection can be used to extract data using \code{dplyr} custom queries. The
\verb{<hub_connection>} class also contains modeling hub metadata.
}
\description{
Connect to data in a model output directory through a Modeling Hub or directly.
Data can be stored in a local directory or in the cloud on AWS or GCS.
}
\section{Functions}{
\itemize{
\item \code{connect_hub()}: connect to a fully configured Modeling Hub directory.

\item \code{connect_model_output()}: connect directly to a \code{model-output} directory. This
function can be used to access data directly from an appropriately set up
model output directory which is not part of a fully configured hub.

}}
\examples{
# Connect to a local simple forecasting Hub.
hub_path <- system.file("testhubs/simple", package = "hubUtils")
hub_con <- connect_hub(hub_path)
hub_con
hub_con <- connect_hub(hub_path, output_type_id_datatype = "character")
hub_con
# Connect directly to a local `model-output` directory
mod_out_path <- system.file("testhubs/simple/model-output", package = "hubUtils")
mod_out_con <- connect_model_output(mod_out_path)
mod_out_con
# Query hub_connection for data
library(dplyr)
hub_con \%>\%
  filter(
    origin_date == "2022-10-08",
    horizon == 2
  ) \%>\%
  collect_hub()
mod_out_con \%>\%
  filter(
    origin_date == "2022-10-08",
    horizon == 2
  ) \%>\%
  collect_hub()
# Connect to a simple forecasting Hub stored in an AWS S3 bucket.
\dontrun{
hub_path <- s3_bucket("hubverse/hubutils/testhubs/simple/")
hub_con <- connect_hub(hub_path)
hub_con
}
}
