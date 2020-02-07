#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
BEGIN {plan tests => 6};
for (qw(PPM PPM::XML::Element PPM::XML::RepositorySummary PPM::XML::PPD
       PPM::XML::PPMConfig PPM::XML::ValidatingElement )) {
  require_ok($_);
}
