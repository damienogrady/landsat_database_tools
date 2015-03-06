#!/usr/bin/perl
#
use strict;
use warnings;


my @scenes = `sqlite3 ls 'select prefix from meta where chosen = 1'`;
chomp @scenes;

my %headers = (
        8 => "sensor=Landsat 8 OLI\nee_dataset_name=LANDSAT_8",
        7 => "sensor=L7 SLC-on (1999-2003)\nee_dataset_name=LANDSAT_ETM",
        5 => "sensor=Landsat 4-5 TM\nee_dataset_name=LANDSAT_TM"
);

for (my $i = 0; $i<=$#scenes; $i+=50) {
        open my $OUTPUT, ">myscenes$i" or die "Couldnae create myscenes file\n";
        print $OUTPUT "GloVis Scene List\n";
        
        my $last = $i + 49;
        $last = ($last > $#scenes) ? $#scenes : $last ;
        foreach my $scene (@scenes[$i..$last]) {
                if ($scene =~ /L.(\d)/) {
                        print $OUTPUT "$headers{$1}\n";
                        print $OUTPUT "$scene\n";
                }
        }
        
        close $OUTPUT;
}

