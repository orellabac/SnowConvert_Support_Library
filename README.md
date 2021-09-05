# SnowConvert Support Library
 
 This repository contains SQL Functions and scripts that are very helpful for migrations 
 from Teradata and other databases to SnowFlake Databases 
 using the [Mobilize.NET](https://www.mobilize.net/) [SnowConvert Tool](https://www.mobilize.net/products/database-migrations/snowconvert)


## [SnowConvert Deploy Tool](https://pypi.org/project/snowconvert-deploy-tool/)

### `sc-deploy-to-db' updates

Version 0.0.4

* Adding support to read connection settings from different sections.
* Adding support to specify an authenticator

Version 0.0.5

* Adding checks to avoid errors when an arguments is not present in the config file

Version 0.0.6

* Adding documentation about environmental variables: SNOW_USER, SNOW_PASSWORD, SNOW_DATABASE, ...
* Improvements for the SplitPattern option, to handle files that have more that one statement
* Adding exception handling while opening the connection
* Fixing defaults and making more options optional so they can always be read from the SNOW_xxx variables
