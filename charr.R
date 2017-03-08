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
  # Sets a string subset. !!FAILS if b[2] contains a comma or whitespace!!
  # @param {chr} a String literal or object of class chr, must be of length 1
  # @param {int/chr} b Vector of length 2, where length(1st) == nchar(2nd);
  #                      1st item: int vector with indices to replace;
  #                      2nd item: length 1 chr vector with characters to replace;
  #                      the integers/characters of the 1st and 2nd item are
  #                      matched from left to right
  # @return {chr} Length 1 chr vector with characters in a replaced according to b;
  #                 if a is an existing object it will be reassigned
  # @example
  #   > 'HELLO WORLD' %i=% c(7:11, 'YYYYY')
  #   [1] "HELLO YYYYY"
  #   x.chr %i=% c(4:8, 'XXXXX')
  stopifnot(is.character(a), length(a) == 1)
  name <- as.character(substitute(a))  # object/variable name
  value <- gsub('"', '', deparse(a))  # character value
  setr <- deparse(substitute(b))  # subset vector with indices and replacement value
  seti <- strsplit(substr(setr, 3, nchar(setr) - 1), ',[^,]*$')[[1]]  # indices
  setv <- trimws(gsub('"', '',  # replacement value  # if err shows up trimws coud be the issue!
                      strsplit(substr(setr, 3, nchar(setr) - 1), '^.*,(?<!\\d)', perl=T)[[1]][2],
                      fixed=T))
  # throw error if the number of indices does not equal the number of values
  if (length(eval(parse(text=seti))) != nchar(setv)) {
    stop('The number of replacement indices does not equal the number of replacement characters.')
  }
  arr <- unlist(strsplit(value, ''))  # character value split into singletons
  i <- 0
  for (c in eval(parse(text=seti))) {  # c is a single index to be replaced
    i <- i + 1  # index of the replacement character
    arr[c] <- substr(setv, i, i)  # replacing
  }
  if (exists(name)) {
    assign(name, paste0(arr, collapse=''), pos=1L)  # assigning in parent scope
  }
  return(paste0(arr, collapse=''))
}