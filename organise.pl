#!/usr/bin/perl
#
use strict;
use warnings;
use File::Copy;


my @list = `ls *.meta`;
chomp @list;

foreach my $item (@list) {
        if($item =~ /([A-Z0-9]{3}(\d{6})(\d{4})(\d{3})[A-Z0-9]{5})/) {
                my ($stem,$tile,$year,$jday) = ($1,$2,$3,$4);
                mkdir $tile unless -d $tile;
                mkdir "$tile/$year" unless -d "$tile/$year";
                move($item, "$tile/$year/$item") or print "Couldn't move $item\n";
                move("$stem.jpg","$tile/$year/$stem.jpg") or print "Couldn't move $stem.jpg\n";
        }
}
