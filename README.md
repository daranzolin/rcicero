# Description

`rcicero` is a bouquet of functions to query the [Cicero API,](https://www.cicerodata.com/api/) 
a useful tool for data on elected officials. Be sure to check the [Terms of Use](https://www.azavea.com/terms-of-use/?_ga=1.70439831.685925080.1469159734) prior to installation.

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
set_user_and_token("your_account_email_address", "your_password")
```

Behind the scenes, `rcicero` stashes the `user` and `token` values into your global options. You must then add the `key` to your `.Renviron`. Warning: the token expires every 24 hours.

# Usage

Three functions make the bulk of `rcicero`: `get_legislative_district()`, `get_official()`, and `get_nonlegislative_district()`. Each returns a data frame with a variety of information. 

```
### Get legislative district data:
santa_clara <- get_legislative_district("3175 Bowers Ave. Santa Clara, CA")

### Get official data:
### By name
lewis <- get_official(first_name = "John", last_name = "Lewis", district_type = "NATIONAL_LOWER")

### By lat/lon coordinates:
x <- get_official(lat = 40, lon = -75.1)

### By address
santa_clara <- get_official("3175 Bowers Ave. Santa Clara, CA")
```

# Future Work

* Inclusion of historical data and maps
* Inclusion of election event data
* Inclusion of more elected official data
* Better error and exception handling
* Facilitation of international queries
* Vignette
* A `shiny` app?
