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

output_model=my-trained-model
mkdir models
python create-model.py eccv models/eccv-model-scracth
python train-detector.py --model models/eccv-model-scracth --name "$output_model" --train-dir samples/train-detector --output-dir models/my-trained-model/ -lr .001 -its 2 -bs 2

output_model_name=models/my-trained-model/"${output_model}"_final.h5
echo "$output_model_name"
if [[ -f "$output_model_name" && -s "$output_model_name" ]]; then
    echo "can train"
    ret=0
else
    echo "can not train";
    exit 1
fi
exit $ret
