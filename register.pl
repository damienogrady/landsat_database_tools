#!/usr/bin/perl
#
# 
###############################################################################################################################
# This creates an sql file from any Landsat metadata that can be found, which you then have to read in to sqlite3.  OK?       #
###############################################################################################################################

use strict;
use warnings;

my @fullpaths = `find -name '*.meta'`;
chomp @fullpaths;
open OUTPUT, ">sql" or die "Could not create sql file.\n";

print OUTPUT <<"EOF";
PRAGMA synchronous = 0;

BEGIN;
Create table if not exists meta (
    prefix TEXT PRIMARY KEY,
    sensor INTEGER,
    cloud_cover NUMERIC,
    acquisition_quality NUMERIC,
    sensor_anomolies TEXT,
    utm_zone NUMERIC,
    date_acquired INTEGER,
    path INTEGER,
    row INTEGER,
    full_partial_scene TEXT,
    image_quality NUMERIC,
    image_quality_vcid_1 NUMERIC,
    image_quality_vcid_2 NUMERIC,
    chosen INTEGER
);
COMMIT;
BEGIN;
EOF

foreach my $fullpath (@fullpaths) {
        open my $input, $fullpath or die "Could not find file $fullpath\n";
        my %item;
        
        my $sensor = '';
        my $prefix = '';
        
        if ($fullpath =~ /(L[A-Z](\d)[^.]+)/) {
                $prefix = $1;
                $sensor = $2;
        } else {
                die "Something wrong with the file name\n";
        }
        
        while (<$input>) {
                chomp;
                my ($key, $value) = split ' = ';
                $item{$key} = $value or next;
        }
        
        close $input;
        
        $item{cloud_cover} = 0 unless defined $item{cloud_cover};
        $item{acquisition_quality} = 0 unless defined $item{acquisition_quality};
        $item{sensor_anomolies} = '' unless defined $item{sensor_anomolies};
        $item{utm_zone} = 0 unless $item{utm_zone};
        $item{date_acquired} = 0 unless defined $item{date_acquired};
        $item{path} = 0 unless defined $item{path};
        $item{row} = 0 unless defined $item{row};
        $item{full_partial_scene} = '' unless defined $item{full_partial_scene};
        $item{image_quality} = 0 unless defined $item{image_quality};
        $item{image_quality_vcid_1} = 0 unless defined $item{image_quality_vcid_1};
        $item{image_quality_vcid_2} = 0 unless defined $item{image_quality_vcid_2};
        
        # my @fields = (qw{prefix sensor cloud_cover acquisition_quality sensor_anomolies utm_zone date_acquired path row full_partial_scene image_quality image_quality_vcid_1
        #        image_quality_vcid_2});
        
        
        my $command = "\tREPLACE INTO  meta VALUES('$prefix',$sensor,$item{cloud_cover},$item{acquisition_quality},'$item{sensor_anomolies}',$item{utm_zone},$item{date_acquired},$item{path},$item{row},'$item{full_partial_scene}',$item{image_quality},$item{image_quality_vcid_1},$item{image_quality_vcid_2},NULL);";
        
        print OUTPUT "$command\n";
}

print OUTPUT "\nCOMMIT;\n";
