#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Cwd;
use Config;
use File::Spec;
use FindBin;
use lib "$FindBin::Bin/lib";
use TestPPM qw($rep_info);
BEGIN {plan tests => 242};

my $cwd = getcwd;
my $ppm_dat = File::Spec->catfile($cwd, qw(t_conf ppm.xml));
$ENV{'PPM_DAT'} = $ppm_dat;
my $path_sep = $Config{path_sep} || ':';
$ENV{PERL5LIB} = join $path_sep, (
  (map {File::Spec->catdir($cwd, 'blib', $_)} qw(arch lib) ), 
  (defined $ENV{PERL5LIB} ? $ENV{PERL5LIB} : ''));

my $tmp = File::Spec->tmpdir;
(my $base = File::Spec->catdir($cwd, qw(t))) =~ s{\\}{/}g;
my $loc_a = "file://$base/PPMPackages";
open (FH, ">$ppm_dat") or die qq{Cannot open $ppm_dat: $!};
print FH <<"EOF";
<PPMCONFIG>
    <PPMVER>0,01_01,0,0</PPMVER>
    <PLATFORM CPU="x86" OSVALUE="MSWin32" OSVERSION="4,0,0,0" />
    <OPTIONS BUILDDIR="$tmp" CLEAN="0" CONFIRM="0" DOWNLOADSTATUS="12345" FORCEINSTALL="0" IGNORECASE="1" MORE="28" ROOT="" TRACE="0" TRACEFILE="PPM_TEST.LOG" VERBOSE="2" />
    <REPOSITORY LOCATION="$loc_a" NAME="PPMPackages" SUMMARYFILE="searchsummary.ppm" />
    <PPMPRECIOUS>Compress-Zlib;Archive-Tar;Digest-MD5;File-CounterFile;Font-AFM;HTML-Parser;HTML-Tree;MIME-Base64;URI;XML-Element;libwww-perl;XML-Parser;SOAP-Lite;PPM;libnet;libwin32</PPMPRECIOUS>
</PPMCONFIG>
EOF

close FH;

require PPM;
ok(-e $ppm_dat, "$ppm_dat exists");

my %opts = PPM::GetPPMOptions();
is($opts{IGNORECASE}, 1, "option IGNORECASE");
is($opts{CLEAN}, 0, "option CLEAN");
is($opts{CONFIRM}, 0, "option CONFIRM");
is($opts{ROOT}, "", "option ROOT");
if (eval {require File::HomeDir}) {
  is($opts{BUILDDIR}, File::Spec->catdir(File::HomeDir->my_home, ".ppm"), "option BUILDDIR");
}
else {
  is($opts{BUILDDIR}, $tmp, "option BUILDDIR");
}
is($opts{DOWNLOADSTATUS}, 12345, "option DOWNLOADSTATUS");
is($opts{FORCE_INSTALL}, 0, "option FORCE_INSTALL");
is($opts{MORE}, 28, "option MORE");
is($opts{TRACE}, 0, "option TRACE");
is($opts{TRACEFILE}, 'PPM_TEST.LOG', "option TRACEFILE");
is($opts{VERBOSE}, 2, "option VERBOSE");

my %reps = PPM::ListOfRepositories();
ok(defined $reps{PPMPackages}, "rep 'PPMPackages' defined");
is($reps{PPMPackages}, $loc_a, "rep 'PPMPackages' location");

my $loc_b = "file://$base/ppms";
PPM::AddRepository(repository => "ppms",
		   location => $loc_b,
		   summaryfile => "searchsummary.ppm",
		   save => 1);
%reps = PPM::ListOfRepositories();
ok(defined $reps{ppms}, "rep 'ppms' defined");
is($reps{ppms}, $loc_b, "rep 'ppms' location");

my %locs = (PPMPackages => $loc_a, ppms => $loc_b);
foreach my $rep (keys %locs) {
  my $loc = $locs{$rep};
  my %packs = PPM::RepositoryPackages(location => $loc);
  ok(defined $packs{$loc}, "packs location '$loc' defined");
  my @packs = keys %{$rep_info->{$rep}};
  my %entries = map {$_ => 1} @{$packs{$loc}};
  foreach my $pack (@packs) {
    ok(defined $entries{$pack}, "entry '$pack' is defined")
  }
}

foreach my $rep (keys %locs) {
  my $loc = $locs{$rep};
  my %sum = PPM::RepositorySummary(location => $loc);
  my $got = $sum{$loc};
  ok(defined $got, "sum location '$loc' defined");
  isa_ok($got, 'HASH');
  my $expect = $rep_info->{$rep};
  foreach my $package (keys %$expect) {
    my $expect_info = $expect->{$package};
    my $got_info = $got->{$package};
    ok(defined $got_info, "'$package' appears");
    isa_ok($got_info, 'HASH');
    foreach my $key (keys %{$expect_info}) {
      is($got_info->{$key}, $expect_info->{$key}, "'$key' appears");
    }
  }
}

foreach my $rep (keys %locs) {
  my $loc = $locs{$rep};
  my $expect = $rep_info->{$rep};
  foreach my $package (keys %$expect) {
    my %got_info = PPM::RepositoryPackageProperties(package => $package,
						    location => $loc);
    my $expect_info = $expect->{$package};
    foreach my $key (keys %{$expect_info}) {
      is($got_info{$key}, $expect_info->{$key}, "'$key' appears");
    }
  }
}

my @queries = qw(Apach Win32 AppCon PPI NoSuchPackage);
my $hits;
foreach my $query (@queries) {
  foreach my $rep (keys %locs) {
    my $loc = $locs{$rep};
    my $expect = $rep_info->{$rep};
    foreach my $package (keys %$expect) {
      if ($package =~ /$query/) {
	push @{$hits->{$query}}, {location => $loc, package => $package};
      }
    }
  }
}
my $ppm_search = join ' ',
  ($^X, File::Spec->catfile($cwd, qw(bin ppm.pl)), 'search');
foreach my $query(@queries) {
  my $cmd = join ' ', ($ppm_search, $query);
  my $got = `$cmd`;
  my $expect = $hits->{$query};
  if ($query eq 'NoSuchPackage') {
    ok(!defined $expect, "'$query' not expected");
  }
  else {
    ok(defined $expect, "results defined");
    isa_ok($expect, 'ARRAY');
    foreach my $hit (@$expect) {
      like($got, qr/$hit->{package}/, "$hit->{package} found");
      like($got, qr/$hit->{location}/, "$hit->{location} found");
    }
  }
}

PPM::RemoveRepository(repository => "PPMPackages",
		      save => 1);
%reps = PPM::ListOfRepositories();
ok(defined $reps{ppms}, "rep 'ppms' defined");
ok(!defined $reps{PPMPackages}, "rep 'PPMPackages' not defined");
