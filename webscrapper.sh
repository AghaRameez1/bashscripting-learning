#!/bin/bash
curl https://www.economy.pk/top-10-tiktokers-of-pakistan/ > index.html

data=$(awk -F\" '/<h2>(.*)<\/h2>/ {print $1}' index.html )
echo $data | sed -E 's/<[^>]*>//g' | sed -E 's/:/\n/g' >>data.txt
