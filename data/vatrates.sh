#!/usr/bin/env bash

mkdir tmp
echo "country,type,rate,situationOn" > tmp/vatrates.csv

for X in $(seq 1 30); do
    curl 'https://ec.europa.eu/taxation_customs/tedb/rest-api/vatSearch' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Accept-Language: en-US,en;q=0.9' \
    -H 'Cache-Control: No-Cache' \
    -H 'Connection: keep-alive' \
    -H 'Content-Type: application/json' \
    --data-raw '{"searchForm":{"selectedMemberStates":["'$X'"],"dateFrom":"2001/01/01","dateTo":"2026/01/31","selectedCategories":[],"selectedCnCodes":[],"selectedCpaCodes":[]},"availableFacets":null,"selectedFacets":null}' > tmp/$X.json
done

for X in $(seq 1 30); do
    COUNTRY=`jq '.initialSearch.availableFacets[0].facets[0].value' tmp/$X.json`
    # one of the 'countries' is null
    if [ "$COUNTRY" == "null" ]; then
        break
    else
        jq '.result[].rates[] | .key + "," + (.value|tostring) +","+ .situationOn' tmp/$X.json | sed -e 's/\(.*\)/'$COUNTRY',\1/g' | sed -e 's/\([a-z0-9"]\)\(,\)\([0-9]\)/\1","\3/g' | sed -e 's/,",/,"",/g' >> tmp/vatrates.csv
    fi
done

cat tmp/vatrates.csv | sort | uniq > vatrates.csv
rm -r tmp