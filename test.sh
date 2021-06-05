#!/bin/bash

./get-networks.sh
cd darknet && make
cd ..
output_csv=/tmp/output/results.csv
./run.sh -i samples/test -o /tmp/output -c "$output_csv"
ret=1
if [[ -f "$output_csv" && -s "$output_csv" ]]; then 
    echo "detection success"
    ret=0
else
    echo "detection failed"; 
    exit 1
fi

./blur.sh -i samples/test -o /tmp/output
count=`ls /tmp/output/*_blurred.png 2>/dev/null | wc -l`
if [ $count != 0 ]
then
	ret=0
else
	exit 1
fi

exit $ret
