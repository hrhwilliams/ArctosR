% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/request.R
\name{RequestBuilder}
\alias{RequestBuilder}
\title{RequestBuilder}
\description{
An Arctos Request
}
\examples{
response <- ArctosR::RequestBuilder$new()
  $set_api_key(API_KEY)
  $set_limit(500)
  $set_query(guid_prefix="MSB:Mamm", locality="New Mexico")
  $set_parts(has_tissue)
  $set_attributes(detected="Orthohauntavirus")
  $perform_request()

}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-RequestBuilder-set_api_key}{\code{RequestBuilder$set_api_key()}}
\item \href{#method-RequestBuilder-set_limit}{\code{RequestBuilder$set_limit()}}
\item \href{#method-RequestBuilder-set_query}{\code{RequestBuilder$set_query()}}
\item \href{#method-RequestBuilder-set_parts}{\code{RequestBuilder$set_parts()}}
\item \href{#method-RequestBuilder-set_attributes}{\code{RequestBuilder$set_attributes()}}
\item \href{#method-RequestBuilder-set_columns}{\code{RequestBuilder$set_columns()}}
\item \href{#method-RequestBuilder-perform_request}{\code{RequestBuilder$perform_request()}}
\item \href{#method-RequestBuilder-clone}{\code{RequestBuilder$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-set_api_key"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-set_api_key}{}}}
\subsection{Method \code{set_api_key()}}{
Sets the Arctos API key to be used for this request.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$set_api_key(key)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{key}}{(\code{string}).}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{RequestBuilder}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-set_limit"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-set_limit}{}}}
\subsection{Method \code{set_limit()}}{
Sets the limit on how many records to initially request
from Arctos.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$set_limit(limit)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{limit}}{(\code{integer(1)}).}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{RequestBuilder}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-set_query"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-set_query}{}}}
\subsection{Method \code{set_query()}}{
Sets the query parameters to use to search Arctos
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$set_query(query)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{query}}{(\code{list}).}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{RequestBuilder}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-set_parts"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-set_parts}{}}}
\subsection{Method \code{set_parts()}}{
Set parts to query over
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$set_parts(parts)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{parts}}{(\code{list}).}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{RequestBuilder}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-set_attributes"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-set_attributes}{}}}
\subsection{Method \code{set_attributes()}}{
Set attributes to query over
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$set_attributes(attributes)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{attributes}}{(\code{list}).}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{RequestBuilder}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-set_columns"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-set_columns}{}}}
\subsection{Method \code{set_columns()}}{
Sets the columns in the dataframe returned by Arctos
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$set_columns(cols)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{cols}}{(\code{list}).}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\link{RequestBuilder}.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-perform_request"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-perform_request}{}}}
\subsection{Method \code{perform_request()}}{
Builds and sends the request to Arctos
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$perform_request()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\link{RequestBuilder}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-RequestBuilder-clone"></a>}}
\if{latex}{\out{\hypertarget{method-RequestBuilder-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{RequestBuilder$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
