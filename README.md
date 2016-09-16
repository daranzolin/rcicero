![](https://www.azavea.com/wp-content/uploads/2015/03/cicero_1000px.jpg)

# Description

`rcicero` is a bouquet of functions to query the [Cicero API,](https://www.cicerodata.com/api/) 
a useful tool for data on elected officials. Be sure to check Cicero's [Terms of Use](https://www.azavea.com/terms-of-use/?_ga=1.70439831.685925080.1469159734) prior to installation.

# Required Packages

`rcicero` requires three packages under the hood: `httr`, `dplyr`, and `tidyjson`. If you work with nested JSON on a semi-regular basis, I highly recommend `tidyjson`. 

# Installation

`rcicero` is not on CRAN, but can be installed via:
```
devtools::install_github("daranzolin/rcicero")
library(rcicero)
```

# Setup
Some prep work is required before usage. The API requires three parameters: (1) an API key; (2) a user id; and (3) an API token. First, [create an 
account](https://www.cicerodata.com/free-trial/) and obtain your API key in your profile. Creating an account is free, and you will be granted 1000 free credits (1 credit per query). Further use will require the purchase of additional credits.

Once you obtain your key, run:

```
set_token_and_user("your_account_email_address", "your_password")
[1] "Your Cicero API user and token options have been set."
```

Behind the scenes, `rcicero` stashes the `user` and `token` values into your global options. You must then add the `key` to your `.Renviron`, as `"CICERO_API_KEY"`. For help on setting up your .Renviron (and everything else R-related) see Jenny Bryan's [Stat545 page.](http://stat545.com/bit003_api-key-env-var.html)  Warning: the API token expires every 24 hours.

# Usage

Four functions make the bulk of `rcicero`: `get_legislative_district()`, `get_official()`, `get_nonlegislative_district()`, and `get_upcoming_elections()`. Each returns a `data.frame` object, with the exception of `get_official()`, which returns a `list` of `data.frame`s. 

```
### Get legislative district data:
santa_clara <- get_legislative_district(seach_loc = "3175 Bowers Ave. Santa Clara, CA")

### Get official data:
### By name
lewis <- get_official(first_name = "John", last_name = "Lewis", district_type = "NATIONAL_LOWER")

### By lat/lon coordinates:
o <- get_official(lat = 40, lon = -75.1)

###Get upcoming elections:
e <- get_upcoming_elections(is_state = TRUE, elections = 4)

###Get non-legislative district information
nld <- get_nonlegislative_district(search_loc = "3175 Bowers Ave. Santa Clara, CA", type = "SCHOOL")

### Get map data (work in progress)
map <- get_map(state = "CA", district_type = "NATIONAL_LOWER", district_id = 5)
```

# Future Work

* Inclusion of historical data and maps
* Better querying
* Better error and exception handling
* Tests
* Vignette
* A `shiny` app?
