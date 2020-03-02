library(reprex)

tmp <- file.path(tempdir(), "foofy")
reprex({
  x <- 1:4
  y <- 2:5
  df <- data.frame(x = x, y = y)
  dt$x
}, outfile = tmp)
list.files(dirname(tmp), pattern = "foofy")


# provide code as an expression
reprex(rbinom(3, size = 10, prob = 0.5))
reprex({y <- 1:4; mean(y)})
reprex({y <- 1:4; mean(y)}, style = TRUE)

# note that you can include newlines in those brackets
# in fact, that is often a good idea
reprex({
  x <- 1:4
  y <- 2:5
  x + y
})

## provide code via character vector
reprex(input = c("x <- 1:4", "y <- 2:5", "x + y"))

## if just one line, terminate with '\n'
reprex(input = "rnorm(3)\n")

## customize the output comment prefix
reprex(rbinom(3, size = 10, prob = 0.5), comment = "#;-)")

# override a default chunk option
reprex({
  #+ setup, include = FALSE
  knitr::opts_chunk$set(collapse = FALSE)
  
  #+ actual-reprex-code
  (y <- 1:4)
  median(y)
})

# add prose, use general markdown formatting
reprex({
  #' # A Big Heading
  #'
  #' Look at my cute example. I love the
  #' [reprex](https://github.com/tidyverse/reprex#readme) package!
  y <- 1:4
  mean(y)
}, advertise = FALSE)

# read reprex from file
tmp <- file.path(tempdir(), "foofy.R")
writeLines(c("x <- 1:4", "mean(x)"), tmp)
reprex(input = tmp)

# read from file and write to similarly-named outfiles
reprex(input = tmp, outfile = NA)
list.files(dirname(tmp), pattern = "foofy")

# clean up
file.remove(list.files(dirname(tmp), pattern = "foofy", full.names = TRUE))

# write rendered reprex to file
tmp <- file.path(tempdir(), "foofy")
reprex({
  x <- 1:4
  y <- 2:5
  x + y
}, outfile = tmp)
list.files(dirname(tmp), pattern = "foofy")

# clean up
file.remove(list.files(dirname(tmp), pattern = "foofy", full.names = TRUE))

# write reprex to file AND keep figure local too, i.e. don't post to imgur
tmp <- file.path(tempdir(), "foofy")
reprex({
  #+ setup, include = FALSE
  knitr::opts_knit$set(upload.fun = identity)
  
  #+ actual-reprex-code
  #' Some prose
  ## regular comment
  (x <- 1:4)
  median(x)
  plot(x)
}, outfile = tmp)
list.files(dirname(tmp), pattern = "foofy")

# clean up
unlink(
  list.files(dirname(tmp), pattern = "foofy", full.names = TRUE),
  recursive = TRUE
)

## target venue = Stack Overflow
## https://stackoverflow.com/editing-help
ret <- reprex({
  x <- 1:4
  y <- 2:5
  x + y
}, venue = "so")
ret

## target venue = R, also good for email or Slack snippets
ret <- reprex({
  x <- 1:4
  y <- 2:5
  x + y
}, venue = "R")
ret

## target venue = html
ret <- reprex({
  x <- 1:4
  y <- 2:5
  x + y
}, venue = "html")
ret

## include prompt and don't comment the output
## use this when you want to make your code hard to execute :)
reprex({
  #+ setup, include = FALSE
  knitr::opts_chunk$set(comment = NA, prompt = TRUE)
  
  #+ actual-reprex-code
  x <- 1:4
  y <- 2:5
  x + y
})

## leading prompts are stripped from source
reprex(input = c("> x <- 1:3", "> median(x)"))

## End(Not run)