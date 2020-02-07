package TestPPM;
use strict;
use warnings;

use base qw(Exporter);
use vars qw(@EXPORT_OK $rep_info);
@EXPORT_OK = qw($rep_info);

$rep_info->{PPMPackages}
  = {
     'PPI' => {
	       'ABSTRACT' => 'Parse, Analyze and Manipulate Perl (without perl)',
	       'TITLE' => 'PPI',
	       'NAME' => 'PPI',
	       'PERLCORE_VER' => undef,
	       'AUTHOR' => 'Adam Kennedy <cpan@ali.as>, L<http://ali.as/>',
	       'VERSION' => '1,117,0,0'
	      },
     'Apache-Authen-Program' => {
				 'ABSTRACT' => 'mod_perl external program authentication module',
				 'TITLE' => 'Apache-Authen-Program',
				 'NAME' => 'Apache-Authen-Program',
				 'PERLCORE_VER' => undef,
				 'AUTHOR' => 'Mark Leighton Fisher <mark-fisher@fisherscreek.com>',
				 'VERSION' => '0,93,0,0'
				},
     'mod_perl' => {
		    'ABSTRACT' => 'Embed a Perl interpreter in the Apache/2.0 HTTP server',
		    'TITLE' => 'mod_perl',
		    'NAME' => 'mod_perl',
		    'PERLCORE_VER' => undef,
		    'AUTHOR' => 'Philippe M. Chiasson <gozer@cpan.org>',
		    'VERSION' => '2,0,2,0'
		   },
     'AppConfig' => {
		     'ABSTRACT' => 'AppConfig is a bundle of Perl5 modules for reading configuration files and parsing command line arguments.',
		     'TITLE' => 'AppConfig',
		     'NAME' => 'AppConfig',
		     'PERLCORE_VER' => undef,
		     'AUTHOR' => 'Andy Wardley <abw@wardley.org>',
		     'VERSION' => '1,56,0,0'
		    },
     'Archive-Zip' => {
		       'ABSTRACT' => 'Provide an interface to ZIP archive files.',
		       'TITLE' => 'Archive-Zip',
		       'NAME' => 'Archive-Zip',
		       'PERLCORE_VER' => undef,
		       'AUTHOR' => 'Ned Konz (perl@bike-nomad.com)',
		       'VERSION' => '1,1,0,0'
		      },
     'Apache-Session' => {
			  'ABSTRACT' => 'A persistence framework for session data',
			  'TITLE' => 'Apache-Session',
			  'NAME' => 'Apache-Session',
			  'PERLCORE_VER' => undef,
			  'AUTHOR' => 'Casey West <casey@geeknest.com>',
			  'VERSION' => '1,80,0,0'
			 }
    };

$rep_info->{ppms}
  = {
     'File-HomeDir' => {
			'ABSTRACT' => 'Get the home directory for yourself or other users',
			'TITLE' => 'File-HomeDir',
			'NAME' => 'File-HomeDir',
			'PERLCORE_VER' => undef,
			'AUTHOR' => 'Adam Kennedy (cpan@ali.as)',
			'VERSION' => '0,58,0,0'
		       },
     'Win32API-Registry' => {
			     'ABSTRACT' => 'Low-level access to Win32 system API calls from WINREG.H',
			     'TITLE' => 'Win32API-Registry',
			     'NAME' => 'Win32API-Registry',
			     'PERLCORE_VER' => undef,
			     'AUTHOR' => 'Tye McQueen (tye@metronet.com)',
			     'VERSION' => '0,27,0,0'
			    },
     'Win32-TieRegistry' => {
			     'ABSTRACT' => 'Powerful and easy ways to manipulate a registry [on Win32 for now]',
			     'TITLE' => 'Win32-TieRegistry',
			     'NAME' => 'Win32-TieRegistry',
			     'PERLCORE_VER' => undef,
			     'AUTHOR' => 'Tye McQueen (tye@metronet.com)',
			     'VERSION' => '0,25,0,0'
			    },
     'Archive-Tar' => {
		       'ABSTRACT' => 'Manipulates TAR archives',
		       'TITLE' => 'Archive-Tar',
		       'NAME' => 'Archive-Tar',
		       'PERLCORE_VER' => undef,
		       'AUTHOR' => 'Jos Boumans (kane@cpan.org)',
		       'VERSION' => '1,30,0,0'
		      },
     'AppConfig' => {
		     'ABSTRACT' => 'AppConfig is a bundle of Perl5 modules for reading configuration files and parsing command line arguments.',
		     'TITLE' => 'AppConfig',
		     'NAME' => 'AppConfig',
		     'PERLCORE_VER' => undef,
		     'AUTHOR' => 'Andy Wardley, (abw@wardley.org)',
		     'VERSION' => '1,63,0,0'
		    },
     'Bit-Vector' => {
		      'ABSTRACT' => 'Efficient bit vector, set of integers and ``big int\'\' math library',
		      'TITLE' => 'Bit-Vector',
		      'NAME' => 'Bit-Vector',
		      'PERLCORE_VER' => undef,
		      'AUTHOR' => 'Steffen Beyer (sb@engelschall.com)',
		      'VERSION' => '6,4,0,0'
		     },
     'ANSIColor' => {
		     'ABSTRACT' => 'Color output using ANSI escape sequences',
		     'TITLE' => 'ANSIColor',
		     'NAME' => 'ANSIColor',
		     'PERLCORE_VER' => undef,
		     'AUTHOR' => 'Russ Allbery (rra@stanford.edu)',
		     'VERSION' => '1,11,0,0'
		    }
    };

1;
