# Description

`rcicero` is a bouquet of functions to query the [Cicero API,](https://www.cicerodata.com/api/) 
a useful tool for data on elected officials.

# Installation

`rcicero` is not on CRAN, but can be installed via:
```
devtools::install_github("daranzolin/rcicero")
library(rcicero)
```

# Setup
Some prep work is required before usage. The API requires three parameters: (1) an API key; (2) a user id; and (3) an API token. First, create an 
account and obtain your API key in your profile. Creating an account is free, and you will be granted 1000 free credits (1 credit per query), but
you will need to purchase additional credits for further use.

Once you obtain your key, run:

```
get_user_and_token("your_account_email_address", "your_password")
```

This will return a list that includes your user id and token. `rcicero` then requires you to stash these three items in your `.Renviron`. Warning: the token expires
every 24 hours.

# Usage

Two functions make the bulk of `rcicero`: `get_legislative_district()` and `get_official()`. Both return data frames with a variety of information. 

```
### Get legislative district data:
santa_clara <- get_legislative_district("3175 Bowers Ave. Santa Clara, CA")

### Get official data:
### By name
lewis <- get_official(first_name = "John", last_name = "Lewis", district_type = "NATIONAL_LOWER")

### By lat/lon coordinates:
od <- get_official(lat = 40, lon = -75.1)

### By address
santa_clara <- get_official("3175 Bowers Ave. Santa Clara, CA")
```

# Disclaimers
The objects returned by these functions are admittedly...messy. That is, they contain nested list columns and other general untidyness. I'd love to clean that up
when I acquire more time and skill.


