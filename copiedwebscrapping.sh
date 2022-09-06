#!/bin/bash

# just for demo
> URI.txt
URI='?daypartId=1&catId='
URL=https://www.mcdelivery.com.pk/pk/browse/menu.html

# just for demo
for id in 1 2 3 4 5 6 8 10 11 12 14
  do
    echo -e "${URI}${id}" >> URI.txt
done

ARRAY=()
while read -r LINE || [[ -n $LINE ]]
do
    [ "$LINE" ] && ARRAY+=("$LINE")
done < URI.txt
echo $ARRAY

for LINE in "${ARRAY[@]}"
  do
    # curl into file main.tmp~
    echo -e "${URL}${LINE}"
    curl "${URL}${LINE}" > "${0%.*}.tmp~" 2> /dev/null

    # get item name and convert into simple file name
    file="$(grep -w "${LINE##*&}" "${0%.*}.tmp~" | grep -o '<span.*</span>' | cut -d\> -f2 | cut -d\< -f1)"
    file="${file//[^[:alnum:]^.^\/^_^\ -]/}"
    file="${file// /_}"
    while [[ "${file}" =~ "__" ]]
      do
        file="${file//__/_}"
    done

    # fallback file name
    [ "$file" ] || file="file${LINE##*&}"

    # rename main.tmp~ into Deals.html and create empty file Deals.txt
    mv -f "${0%.*}.tmp~" "${file}.html" > "${file}.txt"

    # declare arrays
    product_offset=()
    title=()
    price=()

    for offset in $(grep -bha '<div class="panel panel-default panel-product">' "${file}.html" | cut -d: -f1)
      do
         product_offset+=($offset)
    done
    # file size in bytes as last product_offset
    product_offset+=($(stat -c%s "${file}.html"))
    # count matches
    j=$(grep -hac '<div class="panel panel-default panel-product">' "${file}.html")

    # write array title + price from Deals.html    
    i=0
    while [ $i -lt $j ]
      do
        # calculate product_offset
        beg=${product_offset[$i]}
        end=${product_offset[$((i+1))]}
        len=$(expr ${end:-0} - ${beg:-0})

        # search title within product_offset
        item="$(dd if="${file}.html" bs=1 skip=${beg:-0} count=${len:-0} status=none | grep '<h5 class="product-title">' | cut -d\> -f2 | cut -d\< -f1)"
        title+=("$item")

        # search price within product_offset
        item="$(dd if="${file}.html" bs=1 skip=${beg:-0} count=${len:-0} status=none | grep '<span class="starting-price">' | cut -d\> -f2 | cut -d\< -f1)"
        price+=("$item")

        i=$((i+1))
    done

    echo -e "################################################\n#"
    echo -e "# ${file//_/ }\n#"
    echo -e "################################################\n"

    # read array title + price    
    i=0
    while [ $i -lt $j ]
      do
        # echo -e "(${title[$i]}, ${price[$i]})\n" | tee -a "${file}.txt"
        printf "%s-\tName:\t%s\n\tPrice:\t%s\n\n" $((i+1)) "${title[$i]}" "${price[$i]}" | tee -a "${file}.txt"
        i=$((i+1))
    done
done

exit 0