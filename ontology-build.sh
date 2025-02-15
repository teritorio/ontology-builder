#!/bin/bash

set -e

# Import DOC_TOURISM and DOC_CITY
[[ -f .env ]] && source .env

mkdir -p build

# Tourism
curl -L "${DOC_TOURISM}/export?format=csv&gid=2097204395" > ontology-tourism-superclass.csv
curl -L "${DOC_TOURISM}/export?format=csv&gid=2004915696" > ontology-tourism.csv
curl -L "${DOC_TOURISM}/export?format=csv&gid=1650347976" > ontology-tourism-extra_tags.csv

ruby ontology-build.rb tourism 'Ontology Tourism' \
    ontology-tourism-superclass.csv \
    ontology-tourism.csv \
    ontology-tourism-extra_tags.csv \
    build/teritorio-tourism-ontology-2.0.json

ruby ontology2html.rb build/teritorio-tourism-ontology-2.0.json > build/teritorio-tourism-ontology-2.0.html

# City
curl -L "${DOC_CITY}/export?format=csv&gid=2097204395" > ontology-city-superclass.csv
curl -L "${DOC_CITY}/export?format=csv&gid=2004915696" > ontology-city.csv
curl -L "${DOC_CITY}/export?format=csv&gid=1650347976" > ontology-city-extra_tags.csv

ruby ontology-build.rb city 'Ontology City' \
    ontology-city-superclass.csv \
    ontology-city.csv \
    ontology-city-extra_tags.csv \
    build/teritorio-city-ontology-2.0.json

ruby ontology2html.rb build/teritorio-city-ontology-2.0.json > build/teritorio-city-ontology-2.0.html
