use ExtUtils::MakeMaker;
use Config;
use strict;

# my $ppm_version;
# VERSION: {
#   (eval {require PPM;}) and do {
#     unless ($@) {
#       $ppm_version = 2;
#       last VERSION;
#     }
#   };
#   (eval {require PPM::Config;}) and do {
#     unless ($@) {
#       $ppm_version = 3;
#       last VERSION;
#     }
#   };
#   (eval {require ActivePerl::PPM;}) and do {
#     unless ($@) {
#       $ppm_version = 4;
#       last VERSION;
#     }
#   };
#   $ppm_version = undef;
# }
#
# if (defined $ppm_version and $ppm_version != 2) {
#   warn <<"DEATH";
#
# Version $ppm_version of PPM was found, which probably indicates
# you've installed an ActivePerl binary distribution. To prevent
# installation of this (older) PPM version over an ActivePerl PPM
# version, I'm going to exit now.
# DEATH
#   exit 0;
# }

my $eu_version = $ExtUtils::MakeMaker::VERSION;
my %opts;
if ($eu_version >= 5.43) {
  $opts{ABSTRACT_FROM} = q{bin/ppm.pl};
  $opts{AUTHOR} = 'Randy Kobes <r.kobes@uwinnipeg.ca>';
}
WriteMakefile(
	      'NAME'          => 'PPM',
	      'VERSION_FROM'  => 'bin/ppm.pl', # finds $VERSION
	      'EXE_FILES'     => [ "bin/ppm.pl" ],
	      'PREREQ_PM'     => { 'Archive::Tar'     => 1.08,
				   'Compress::Zlib'   => 0,
				   'XML::Parser'      => 2.09,
				   'Archive::Zip'     => 1.02,
				 },
              'dist' => { TAR => 'ptar', TARFLAGS => '-c -C -f' },
	      'clean' => { FILES => 'ppm.xml t_conf/ppm.xml' },
	      %opts,
	     );

my $repositories = {
#    '5.012' => {
#      ($Config{archname} =~ m/x86/) ?
#        ( #32bit
#          #'ActiveState' => {location => 'http://ppm4.activestate.com/MSWin32-x86/5.12/1200/', summaryfile => 'package.xml'},
#          'Trouchelle' => {location => 'http://trouchelle.com/ppm12', summaryfile => 'package.xml'},
#          'Bribes'      => {location => 'http://www.bribes.org/perl/ppm', summaryfile => 'searchsummary.ppm'}, #all versions
#          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'searchsummary.ppm'}, #all versions, all platforms
#        )
#      :
#        ( #64bit
#          #'ActiveState' => {location => 'http://ppm4.activestate.com/MSWin32-x64/5.12/1200/', summaryfile => 'package.xml'},
#          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'searchsummary.ppm'}, #all versions, all platforms
#        )
#    },
#    '5.014' => {
#      ($Config{archname} =~ m/x86/) ?
#        ( #32bit
#          #'ActiveState' => {location => 'http://ppm4.activestate.com/MSWin32-x86/5.14/1400/', summaryfile => 'package.xml'},
#          'Trouchelle'  => {location => 'http://trouchelle.com/ppm14', summaryfile => 'package.xml'},
#          'Bribes'      => {location => 'http://www.bribes.org/perl/ppm', summaryfile => 'searchsummary.ppm'}, #all versions
#          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'searchsummary.ppm'}, #all versions, all platforms
#        )
#      :
#        ( #64bit
#          #'ActiveState' => {location => 'http://ppm4.activestate.com/MSWin32-x64/5.14/1400/', summaryfile => 'package.xml'},
#          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'searchsummary.ppm'}, #all versions, all platforms
#        )
#    },
#    '5.016' => {
#      ($Config{archname} =~ m/x86/) ?
#        ( #32bit
#          #'ActiveState' => {location => 'http://ppm4.activestate.com/MSWin32-x86/5.16/1600/', summaryfile => 'package.xml'},
#          'Trouchelle'  => {location => 'http://trouchelle.com/ppm16', summaryfile => 'package.xml'},
#          'Bribes'      => {location => 'http://www.bribes.org/perl/ppm', summaryfile => 'searchsummary.ppm'}, #all versions
#          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'searchsummary.ppm'}, #all versions, all platforms
#        )
#      :
#        ( #64bit
#          #'ActiveState' => {location => 'http://ppm4.activestate.com/MSWin32-x64/5.16/1600/', summaryfile => 'package.xml'},
#          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'searchsummary.ppm'}, #all versions, all platforms
#        )
#    },
    '_DEFAULT_' => {
      ($Config{archname} =~ m/x86/) ?
        ( #32bit
          'Bribes'      => {location => 'http://www.bribes.org/perl/ppm', summaryfile => 'package.xml'}, #all versions
          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'package.xml'}, #all versions, all platforms
        )
      :
        ( #64bit
          'Sisyphusion' => {location => 'http://www.sisyphusion.tk/ppm', summaryfile => 'package.xml'}, #all versions, all platforms
        )
    },
  };

ppm_config();

sub ppm_config {
   my $ppm = 'ppm.xml';
   my $perl_version = substr($],0,5); # '5.014' / '5.012'
   my $reps = exists $repositories->{$perl_version} ? $repositories->{$perl_version} : $repositories->{_DEFAULT_};
   my $cpu = ($Config{archname} =~ m/x86/) ? 'x86' : 'x64';

   my %subs = ( '%OSNAME%'    => $Config{osname},
                '%OSVERSION%' => '4,0,0,0',
                '%TEMP%'      => $ENV{TMP} || $ENV{TEMP},
                '%SITELIB%'   => $Config{sitelib},
                '%PERLDIR%'   => $Config{prefix},
                '%CPU%'       => $cpu,
		'%INSTDATE%'  => scalar localtime,
              );
   open(PPM, ">$ppm") or die "Cannot open $ppm: $!";
   while(<DATA>) {
     if ($_ =~ /^\s+<PPMPRECIOUS>/) {
      foreach my $name(sort keys %$reps) {
         my $loc = $reps->{$name}->{location};
         my $sf = $reps->{$name}->{summaryfile};
         print PPM << "END";
    <REPOSITORY LOCATION="$loc" NAME="$name" SUMMARYFILE="$sf" />
END
       }
       print PPM $_;
       next;
     }
     foreach my $key (keys %subs) {
       s/$key/$subs{$key}/g;
     }
     print PPM $_;
   }
   close PPM;
}

sub MY::postamble {

my $copy = $^O eq 'MSWin32' ? 'copy ppm.xml blib\lib' : 'cp ppm.xml blib/lib';
my $postamble = '
all ::';

$postamble .= '
	mv blib/script/ppm.pl blib/script/ppm
	mv blib/man1/ppm.pl.1 blib/man1/ppm.1' unless ($^O eq 'MSWin32');

$postamble .= "
	$copy" unless ( -f "$Config{sitelib}/ppm.xml" or (defined $Config{vendorlib} and -f "$Config{vendorlib}/ppm.xml") );

    $postamble;
}

__DATA__
<PPMCONFIG>
    <PPMVER>0,01_04,0,0</PPMVER>
    <PLATFORM CPU="%CPU%" OSVALUE="%OSNAME%" OSVERSION="%OSVERSION%" />
    <OPTIONS BUILDDIR="%TEMP%" CLEAN="1" CONFIRM="1" DOWNLOADSTATUS="16384" FORCEINSTALL="1" IGNORECASE="1" MORE="24" ROOT="" TRACE="0" TRACEFILE="PPM.LOG" VERBOSE="1" />
    <PPMPRECIOUS>Compress-Zlib;Archive-Tar;Digest-MD5;File-CounterFile;Font-AFM;HTML-Parser;HTML-Tree;MIME-Base64;URI;XML-Element;libwww-perl;XML-Parser;SOAP-Lite;PPM;libnet;libwin32</PPMPRECIOUS>
</PPMCONFIG>
