# Easy string concatenation
'%+%' <- function(a, b) UseMethod('%+%')  # Generic concat operator
'%+%.character' <- function(a, b) {  # String concat operator
  # Concatenates two length 1 chr vectors.
  # @param {chr} a Length 1 chr vector 
  # @param {chr} b Length 1 chr vector
  # @return {chr} Length 1 chr vector
  # @example
  #   > 'heck' %+% ' meck'
  #  [1] 'heck meck'
  stopifnot(length(a) == 1, length(b) == 1)
  return(paste0(a, b))
}

# Easy character repetition
'%r%' <- function(a, b) UseMethod('%r%')  # Generic repeat operator
'%r%.character' <- function(a, b) {  # String repeat operator
  # Repeats a length 1 chr vector b times.
  # @param {chr} a Length 1 chr vector to be repeated
  # @param {int} b Length 1 integer vector specifiying number of repetitions
  # @return {chr} Length 1 chr vector
  # @example
  #   > 'Hi' %r% 3
  #  [1] 'HiHiHi'
  stopifnot(length(a) == 1, length(b) == 1)
  return(paste0(rep(a, b), collapse=''))
}

# Easy character subsetting
'%i%' <- function(a, b) UseMethod('%i%')
'%i%.character' <- function(a, b) {
  # Gets a character subset.
  # @param {chr} a Chr vector, must be of length 1
  # @param {int} b Integer vector with indices 4 subsetting
  # @return {chr} Length 1 chr vector
  # @example
  #   > 'Fraudulent Activities' %i% 1:5
  #   [1] "Fraud"
  #   > y <- 'Get rid of dumb characters' %i% -c(12:16)
  stopifnot(length(a) == 1, nchar(a) > 0, is.numeric(b))
  arr <- unlist(strsplit(a, ''))
  x <- arr[b]
  if (anyNA(x)) x <- x[!is.na(x)]
  return(paste0(x, collapse=''))
}

'%i=%' <- function(a, b) UseMethod('%i=%')
'%i=%.character' <- function(a, b) {
  # Sets a character subset.
  # @param {chr} a Chr vector, must be of length 1
  # @param {int/chr} b Vector of length 2, where length(1st) == length(2nd);
  #                      1st item: int vector with indices to replace;
  #                      2nd item: chr vector with characters to replace;
  #                      the integers/characters of the 1st and 2nd item are
  #                      matched from left to right
  # @return {chr} Length 1 chr vector with characters in a replaced according to b
  # @example
  #   > 'HELLO WORLD' %i=% c(7:11, rep('Y', 5))
  #   [1] "HELLO YYYYY"
  #   > x <- 'Frank Fraud'
  #   > x %i=% c(c(1, 9), c('C', '@'))
  #   [1] "Crank Fr@ud"
  stopifnot(length(a) == 1, nchar(a) > 0)
  value <- gsub('"', '', deparse(a))  # character value
  setr <- eval(substitute(b))  # subset vector with indices and replacement values
  seti <- as.integer(setr[1:(length(setr) / 2)])  # indices
  setv <- setr[(length(setr) / 2 + 1):length(setr)]  # vector of replacement values
  # throwing errors
  if (!all(seti %in% 1:nchar(value))) stop('Replacement indices out of bounds!')
  if (!all(is.integer(seti) && is.character(setv))) stop('Invalid input types!')
  if (!all(nchar(setv) == 1)) stop('Each replacement value must be a single character only!')
  if (length(setr) %% 2 != 0) {
    stop('The number of replacement indices does not equal the number of replacement characters.')
  }
  # mapping
  arr <- unlist(strsplit(value, ''))  # character value split into singletons
  i <- 0
  for (index in seti) {  # index to be replaced
    i <- i + 1  # index of the replacement character
    arr[index] <- setv[i]  # replacing
  }
  return(paste0(arr, collapse=''))
}

# Easy character insertion 
'%ii=%' <- function(a, b) UseMethod('%ii=%')
'%ii=%.character' <- function(a, b) {
  # Inserts characters into a length 1 chr vector after specified indices.
  # @param {chr} a Chr vector, must be of length 1
  # @param {int/chr} b Vector of length 2, where length(1st) == length(2nd);
  #                      1st item: int vector with indices to insert after;
  #                      2nd item: chr vector with strings to insert;
  #                      the integers/strings of the 1st and 2nd item are
  #                      matched from left to right
  # @return {chr} Length 1 chr vector with the given characters inserted
  # @example
  #   > 'HELLO WORLD' %ii=% c(c(5, 11), c(',', '!!!'))
  #   [1] "HELLO, WORLD!!!"
  #   > 'ABC' %ii=% c(1:2, c('|', '|'))
  #   [1] "A|B|C"
  stopifnot(length(a) == 1)
  value <- gsub('"', '', deparse(a))  # character value
  setr <- eval(substitute(b))  # subset vector with indices and replacement values
  seti <- as.integer(setr[1:(length(setr) / 2)])  # indices
  setv <- setr[(length(setr) / 2 + 1):length(setr)]  # vector of replacement values
  # throwing errors
  if (!all(seti %in% 1:nchar(value))) stop('Some indices are out of bounds!')
  if (!all(is.integer(seti) && is.character(setv))) stop('Invalid input types!')
  if (length(setr) %% 2 != 0) {
    stop('The number of replacement indices does not equal the number of replacement characters.')
  }
  # mapping
  arr <- unlist(strsplit(value, ''))  # character value split into singletons
  m <- list(i=0, head=0, accu=list())  # memory
  for (index in seti) {  # insert after original's index
    m$i <- m$i + 1  # index of slice
    m$accu[[m$i]] <- c(arr[m$head:index], setv[m$i])  # split and append
    m$head <- index + 1  # remember last slice index aka new head
  }
  # consume remainder
  if (m$head %in% 1:length(arr)) {
    m$accu[[m$i + 1]] <- arr[m$head:length(arr)]
  }
  return(paste0(unlist(m$accu), collapse=''))
}