#!/bin/bash


/usr/bin/xmessage  `sqlite3 ls 'select count(prefix) from meta where chosen is null;'`
