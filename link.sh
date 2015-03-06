#!/bin/bash
if ! [ -d Chosen ]
then
        mkdir Chosen
fi
for prefix in `sqlite3 ls 'select prefix from meta where chosen =1'`
do
        pwd=`pwd`
        file=`find $pwd -name "$prefix*.jpg"`
        ln -s "$file" Chosen/
done
