# A little intro walk-through script for dolt
# Based on https://ecohealthalliance.github.io/doltr/articles/doltr.html

library(doltr) # The doltr package, remotes::install("ecohealthalliance/doltr")

# First, we clone a database into our project directory.  We can work with
# remote databases, b
dolt_clone("doltr/nycflights")

# doltr uses an environment variable to set the default database
Sys.setenv(DOLT_DIR="nycflights")

# doltr

# With this set, `dolt()` always provides a connection.  It has a print function
# to show you information about the database.
dolt()

# List the remotes. This function takes `dolt()` as the default argument.
dolt_remotes()

# The DBI interface provides low-level interface to SQL databases
library(DBI)

dbListTables(dolt())
dbReadTable(dolt(), "airlines")

# You can use the dbplyr interface to query a database and pull the results
library(dplyr)
library(dbplyr)
tbl(dolt(), "flights") %>%
  filter(origin == "EWR", dest == "MDW") %>%
  head() %>%
  collect()

# Modify the database by adding a table
dbWriteTable(dolt(), "mtcars", mtcars)

# dolt_*() functions give you information about the database or manipulate
dolt_status() # Modifications to the database
as_tibble(dolt_status())

dolt_log() # History of commits

dolt_use("raa6u0g1bk1pi1p200f6pq7tpoobn6cl")  # Set the database to a commit

dolt()  # Look at the status
dbListTables(dolt()) # List the tables

dolt_use()  # Go back to the HEAD

dolt()  # Look at the status
dbListTables(dolt()) # List the tables

# Alternatively, we can is as_of to read the database at a commit or date
dbReadTable(dolt(), "flights", as_of = "2022-05-01")

# Now, let's make some changes
dolt_add("mtcars")
dolt_status()
as_tibble(dolt_status())

# We can commit,
# dolt_commit(message = "Add mtcars table") Set message in the function, or
dolt_commit() # Do it interactively
dolt_status()
dolt_last_commit()

# And push to DoltHub
dolt_push()

# Hey, we can do this all in the RStudio Connections pane!

dolt_pane()
dbWriteTable(dolt(), "mtcars", rbind(mtcars, mtcars), overwrite = TRUE)

# Also, there are ways in and out of the dolt ecosystem
v1 <- readr::read_csv("https://www.dolthub.com/csv/doltr/nycflights/88kolt95duve79hm59s4kvsntrak03dn/airlines")
v2 <- readr::read_csv("https://www.dolthub.com/csv/doltr/nycflights/766q8e7hfe08qn46h1ksuidr5363gq9s/airlines")
library(daff)
daff::diff_data(v2, v1) |> render_diff()

dolt_dump(format = "parquet")
