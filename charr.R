# Easy string concatenation
'%+%' <- function(a, b) UseMethod('%+%')  # Generic concat operator
'%+%.character' <- function(a, b) paste0(a, b)  # String concat operator
# 'sakawa' %+% ' spirit' %+% ' gives strength'  # 419

# Easy string repetition
'%r%' <- function(a, b) UseMethod('%r%')  # Generic repeat operator
'%r%.character' <- function(a, b) {  # String repeat operator
  stopifnot(length(a) == 1, length(b) == 1)
  return(paste0(rep(a, b), collapse=''))
}

# Easy string subsetting
'%i%' <- function(a, b) UseMethod('%i%')
'%i%.character' <- function(a, b) {
  # Gets a string subset.
  # @param {chr} a String literal or object of class character, must be of length 1
  # @param {int} b Integer vector with indices 4 subsetting
  # @return {chr} Character subset as 1 string
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
  # Sets a string subset.
  # @param {chr} a String literal or object of class chr, must be of length 1
  # @param {int/chr} b Vector of length 2, where length(1st) == length(2nd);
  #                      1st item: int vector with indices to replace;
  #                      2nd item: chr vector with characters to replace;
  #                      the integers/characters of the 1st and 2nd item are
  #                      matched from left to right
  # @return {chr} Length 1 chr vector with characters in a replaced according to b;
  #                 if a is an existing object it will be reassigned
  # @example
  #   > 'HELLO WORLD' %i=% c(7:11, rep('Y', 5))
  #   [1] "HELLO YYYYY"
  #   > x <- 'Frank Fraud'
  #   > x %i=% c(c(1, 9), c('C', '@'))
  #   [1] "Crank Fr@ud"
  stopifnot(is.character(a), length(a) == 1)
  value <- gsub('"', '', deparse(a))  # character value
  setr <- eval(substitute(b))  # subset vector with indices and replacement values
  seti <- as.integer(setr[1:(length(setr) / 2)])  # indices
  setv <- setr[(length(setr) / 2 + 1):length(setr)]  # vector of replacement values
  # throwing errors
  if (length(setr) %% 2 != 0) {
    stop('The number of replacement indices does not equal the number of replacement characters.')
  }
  if (!all(nchar(setv) == 1)) stop('Each replacement value must be a single character only!')
  if (!all(seti %in% 1:nchar(value))) stop('Replacement indices out of bounds!')
  # mapping
  arr <- unlist(strsplit(value, ''))  # character value split into singletons
  i <- 0
  for (index in seti) {  # index to be replaced
    i <- i + 1  # index of the replacement character
    arr[index] <- setv[i]  # replacing
  }
  return(paste0(arr, collapse=''))
}

'%ii=%' <- function(a, b) UseMethod('%ii=%')
'%ii=%.character' <- function(a, b) {
  # Inserts characters into a string after specified indices.
  # @param {chr} a String literal or object of class chr, must be of length 1
  # @param {int/chr} b Vector of length 2, where length(1st) == length(2nd);
  #                      1st item: int vector with indices to insert after;
  #                      2nd item: chr vector with strings to insert;
  #                      the integers/strings of the 1st and 2nd item are
  #                      matched from left to right
  # @return {chr} Length 1 chr vector with the given strings inserted;
  #                 if a is an existing object it will be reassigned
  # @example
  #   > 'HELLO WORLD' %ii=% c(c(5, 11), c(',', '!!!'))
  #   [1] "HELLO, WORLD!!!"
  #   > 'ABC' %ii=% c(1:2, c('|', '|'))
  #   [1] "A|B|C"
  stopifnot(is.character(a), length(a) == 1)
  value <- gsub('"', '', deparse(a))  # character value
  setr <- eval(substitute(b))  # subset vector with indices and replacement values
  seti <- as.integer(setr[1:(length(setr) / 2)])  # indices
  setv <- setr[(length(setr) / 2 + 1):length(setr)]  # vector of replacement values
  # throwing errors
  if (!all(is.integer(seti) || is.character(setv))) stop('Falsy input!')
  if (length(setr) %% 2 != 0) {
    stop('The number of replacement indices does not equal the number of replacement characters.')
  }
  if (!all(seti %in% 1:nchar(value))) stop('Some indices are out of bounds...')
  # mapping
  arr <- unlist(strsplit(value, ''))  # character value split into singletons
  m <- list(i=0, head=0, accu=list())  # memory
  for (index in seti) {  # insert after original's index
    m$i <- m$i + 1  # index of slice
    m$accu[[m$i]] <- c(arr[m$head:index], setv[m$i])  # split and append
    m$head <- index + 1  # remember last slice index aka new head
  }
  if (m$head %in% 1:length(arr)) m$accu[[m$i + 1]] <- arr[m$head:length(arr)]  # consume remainder
  return(paste0(unlist(m$accu), collapse=''))
}