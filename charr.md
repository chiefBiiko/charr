charr - character operators 4 R
================
March 12, 2017

R is a lovely programming language. Nonetheless, working with strings in R can be a little cumbersome. <code>charr</code> attempts to make working with strings and characters in R as easy as ABC.

------------------------------------------------------------------------

Using charr
-----------

<code>source('<https://github.com/chiefBiiko/charr/raw/master/charr.R>')</code>

------------------------------------------------------------------------

Character concatenation
-----------------------

Concatenate length 1 character vectors with the <code>%+%</code> operator:

``` r
z <- ' makes lucky'
'sakawa' %+% ' spirit' %+%  z
```

    [1] "sakawa spirit makes lucky"

------------------------------------------------------------------------

Character repetition
--------------------

Repeat length 1 character vectors with the <code>%r%</code> operator:

``` r
'saka' %r% 2
```

    [1] "sakasaka"

``` r
'Enter the secret' %+% ('!' %r% 10)
```

    [1] "Enter the secret!!!!!!!!!!"

------------------------------------------------------------------------

Character subsetting
--------------------

Subset length 1 character vectors with the indices of its characters using the <code>%i%</code> and <code>%i=%</code> operators. The former performs a get operation whereas the latter performs a set operation.

> The <code>%i=%</code> and <code>%ii=%</code> operators map their input strings according to their right operand and return the resulting string. Thus, to really perform a set operation on an existing string variable one has to reassign the return value of the corresponding operator.

### Getting characters

Get characters of a length 1 character vector using the <code>%i%</code> operator:

``` r
'Fraudulent Activities' %i% 1:5
```

    [1] "Fraud"

``` r
x <- 'Get rid of dumb characters' %i% -c(12:16)
print(x)
```

    [1] "Get rid of characters"

In order to erase characters wrap their indices in <code>c()</code> prefixed with a minus sign. If the supplied subset indices are out of bounds (exceed the number of characters of the left operand) the return value contains all characters from the supplied start index until the end of the input string.

### Setting characters

Set characters of a length 1 character vector using the <code>%i=%</code> operator:

``` r
'HELLO WORLD' %i=% c(7:11, rep('Y', 5))
```

    [1] "HELLO YYYYY"

``` r
y <- 'no money no funny'
y %i=% c(c(1, 13:17), c('N', rep('X', 5)))
```

    [1] "No money no XXXXX"

The right operand must be a length 2 vector supplying a vector of replacement indices as first item and a vector of replacement values as second item. Note that the replacement indices are matched to the replacement values from left to right. Therefore, the number of replacement indices must equal the number of replacement values. Each replacement value must be a single character.

------------------------------------------------------------------------

Character insertion
-------------------

Insert characters *after* specified indices into a length 1 character vector using the <code>%ii=%</code> operator:

``` r
'HELLO WORLD' %ii=% c(c(5, 11), c(',', '!!!'))
```

    [1] "HELLO, WORLD!!!"

``` r
abc <- 'ABC' %ii=% c(1:2, c('|', '|'))
print(abc) 
```

    [1] "A|B|C"

The right operand must be a length 2 vector supplying a vector of indices after which to insert strings as first item and a vector of insertion values (strings to insert) as second item. Note that the insertion indices are matched to the insertion values from left to right. Therefore, the number of insertion indices must equal the number of insertion values. The insertion values can be multi character strings.
