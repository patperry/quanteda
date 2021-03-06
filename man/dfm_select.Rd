% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dfm_select.R, R/fcm-methods.R
\name{dfm_select}
\alias{dfm_select}
\alias{dfm_remove}
\alias{fcm_select}
\alias{fcm_remove}
\title{select features from a dfm or fcm}
\usage{
dfm_select(x, features = NULL, selection = c("keep", "remove"),
  valuetype = c("glob", "regex", "fixed"), case_insensitive = TRUE,
  min_nchar = 1, max_nchar = 63, verbose = FALSE, ...)

dfm_remove(x, features = NULL, ...)

fcm_select(x, features = NULL, selection = c("keep", "remove"),
  valuetype = c("glob", "regex", "fixed"), case_insensitive = TRUE,
  verbose = TRUE, ...)

fcm_remove(x, features, ...)
}
\arguments{
\item{x}{the \link{dfm} or \link{fcm} object whose features will be selected}

\item{features}{one of: a character vector of features to be selected, a 
\link{dfm} whose features will be used for selection, or a dictionary class
object whose values (not keys) will provide the features to be selected. 
For \link{dfm} objects, see details in the Value section below.}

\item{selection}{whether to \code{keep} or \code{remove} the features}

\item{valuetype}{how to interpret keyword expressions: \code{"glob"} for 
"glob"-style wildcard expressions; \code{"regex"} for regular expressions;
or \code{"fixed"} for exact matching. See \link{valuetype} for details.}

\item{case_insensitive}{ignore the case of dictionary values if \code{TRUE}}

\item{min_nchar, max_nchar}{numerics specifying the minimum and maximum length
in characters for features to be removed or kept; defaults are 1 and 
\href{https://en.wikipedia.org/wiki/Donaudampfschiffahrtselektrizitätenhauptbetriebswerkbauunterbeamtengesellschaft}{79}.
 (Set \code{max_nchar} to \code{NULL} for no upper limit.) These are
applied after (and hence, in addition to) any selection based on pattern
matches.}

\item{verbose}{if \code{TRUE} print message about how many features were 
removed}

\item{...}{supplementary arguments passed to the underlying functions in 
\code{\link[stringi]{stri_detect_regex}}}
}
\value{
A dfm or fcm after the feature selection has been applied.
  
  When \code{features} is a \link{dfm} object, then the returned object will 
  be identical in its feature set to the dfm supplied as the \code{features} 
  argument.  This means that any features in \code{x} not in \code{features} 
  will be discarded, and that any features in found in the dfm supplied as 
  \code{features} but not found in \code{x} will be added with all zero 
  counts.  This is useful when you have trained a model on one dfm, and need 
  to project this onto a test set whose features must be identical.
}
\description{
This function selects or discards features from a dfm or fcm, based on a 
pattern match with the feature names.   The most common usages are to 
eliminate features from a dfm already constructed, such as stopwords, or to 
select only terms of interest from a dictionary.
}
\details{
\code{dfm_remove} and \code{fcm_remove} are simply a convenience
  wrappers to calling \code{dfm_select} and \code{fcm_select} with
  \code{selection = "remove"}.
}
\note{
This function selects features based on their labels.  To select 
  features based on the values of a the document-feature matrix, use 
  \code{\link{dfm_trim}}.
}
\examples{
myDfm <- dfm(c("My Christmas was ruined by your opposition tax plan.", 
               "Does the United_States or Sweden have more progressive taxation?"),
             tolower = FALSE, verbose = FALSE)
mydict <- dictionary(list(countries = c("United_States", "Sweden", "France"),
                          wordsEndingInY = c("by", "my"),
                          notintext = "blahblah"))
dfm_select(myDfm, mydict)
dfm_select(myDfm, mydict, case_insensitive = FALSE)
dfm_select(myDfm, c("s$", ".y"), "keep")
dfm_select(myDfm, c("s$", ".y"), "keep", valuetype = "regex")
dfm_select(myDfm, c("s$", ".y"), "remove", valuetype = "regex")
dfm_select(myDfm, stopwords("english"), "keep", valuetype = "fixed")
dfm_select(myDfm, stopwords("english"), "remove", valuetype = "fixed")

# select based on character length
dfm_select(myDfm, min_nchar = 5)

# selecting on a dfm
textVec1 <- c("This is text one.", "This, the second text.", "Here: the third text.")
textVec2 <- c("Here are new words.", "New words in this text.")
(dfm1 <- dfm(textVec1, verbose = FALSE))
(dfm2a <- dfm(textVec2, verbose = FALSE))
(dfm2b <- dfm_select(dfm2a, dfm1))
setequal(featnames(dfm1), featnames(dfm2b))

# more selection on a dfm
dfm_select(dfm1, dfm2a)
dfm_select(dfm1, dfm2a, selection = "remove")

tmpdfm <- dfm(c("This is a document with lots of stopwords.",
                "No if, and, or but about it: lots of stopwords."),
              verbose = FALSE)
tmpdfm
dfm_remove(tmpdfm, stopwords("english"))
toks <- tokens(c("this contains lots of stopwords",
                 "no if, and, or but about it: lots"),
               removePunct = TRUE)
tmpfcm <- fcm(toks)
tmpfcm
fcm_remove(tmpfcm, stopwords("english"))
}
\keyword{dfm}
