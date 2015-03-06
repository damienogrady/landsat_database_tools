#!/bin/bash
if [ -e ls.bak ]
then
        rm ls.bak
fi
cp ls ls.bak

for prefix in `sqlite3 ls 'select prefix from meta where chosen is null'`
do
        file=`find -name "$prefix*.jpg"`
        display -geometry +100+100 $file &
        ans=$(xmessage -buttons 1:2,0:3,exit:4 -default 1 -print "Select?")
        if [ $ans = exit ]
        then
                killall display
                exit
        fi
        sqlite3 ls "update meta set chosen = $ans where prefix like \"$prefix\""
        killall display
done
