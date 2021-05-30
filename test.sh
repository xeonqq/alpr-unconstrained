#!/bin/bash

./get-networks.sh
cd darknet && make
cd ..
output_csv=/tmp/output/results.csv
./run.sh -i samples/test -o /tmp/output -c "$output_csv"
if [[ -f "$output_csv" && -s "$output_csv" ]]; then 
    echo "success"
    exit 0
else 
    echo "detection failed"; 
    exit 1
fi

