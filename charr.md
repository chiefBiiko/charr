charr - character operators 4 R
================
March 3, 2017

R is a lovely programming language. Nonetheless, working with strings in R can be a little cumbersome. Especially, if one is accustomed to easy string operations as available in Python or JavaScript. <code>charr</code> attempts to make working with strings and characters in R as easy as ABC.

### Using charr

<code>source('<https://github.com/chiefBiiko/charr/raw/master/charr.R>')</code>

### Character concatenation

Concatenate length 1 character vectors with the <code>%+%</code> operator:

``` r
c <- ' makes lucky'
'sakawa' %+% ' spirit' %+%  c
```

    [1] "sakawa spirit makes lucky"

### Character repetition

Repeat length 1 character vectors with the <code>%r%</code> operator:

``` r
'saka' %r% 2
```

    [1] "sakasaka"

``` r
'Enter the secret' %+% ('!' %r% 10)
```

    [1] "Enter the secret!!!!!!!!!!"

### Character subsetting

Subset length 1 character vectors with the indices of its characters using the <code>%i%</code> and <code>%i=%</code> operators. The former performs a get operation, whereas the latter performs a set operation.

#### Getting characters

Get characters of a length 1 character vector using the <code>%i%</code> operator:

``` r
'Fraudulent Activities' %i% 1:5
```

    [1] "Fraud"

``` r
x <- 'Get rid of dumb characters' %i% -c(12:16)
x
```

    [1] "Get rid of characters"

If the supplied subset indices are out of bounds (exceed the number of characters of the left operand) the return value contains all characters from the supplied start index until the end of the input string. In order to erase characters wrap their indices in <code>c()</code> prefixed with a minus sign.

#### Setting characters

Set characters of a length 1 character vector using the <code>%i=%</code> operator:

``` r
'HELLO WORLD' %i=% c(7:11, 'YYYYY')
```

    [1] "HELLO YYYYY"

``` r
y <- 'no money no funny'
y %i=% c(c(1, 13:17), 'NXXXXX')
```

    [1] "No money no XXXXX"

WARNING: Fails if the replacement string contains a comma or whitespace!

The right operand must be a length 2 vector combined with <code>c()</code>, supplying the replacement indices as first item and the replacement values as second item. Note that the replacement indices are matched to the replacement value's single characters from left to right. Therefore, the number of replacement indices must equal the number of characters of the replacement value. In case the left operand is not a string literal but an existing object it is reassigned.
