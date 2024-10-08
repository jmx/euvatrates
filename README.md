# euvatrates
EU VAT Rate tools


## VAT rate fetcher

Bash script to fetch EU tax rates from Taxes in Europe DB
https://ec.europa.eu/taxation_customs/tedb/#/vat-search

### Requirements

* Bash
* curl
* [JQLang](https://jqlang.github.io/)

### Usage

To fetch a CSV with the EU VAT rates
```bash
cd data
./vatrates.sh
```
The result should be a CSV file in data/vatrates.csv