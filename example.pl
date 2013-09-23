#!/usr/bin/env perl
use Time::localtime;
use strict;


# SIG Handlers
$SIG{'INT'} = \&sigIntHandler;
$SIG{'ALRM'} = \&sigAlarmHandler;
my $logfile = "foo.log";
my $logMode = "file";

#keep original Filehandles
open(OLDOUT, ">&STDOUT");
open(OLDERR, ">&STDERR");

# redirect output to STD by default
open STDOUT, '>', $logfile;
open STDERR, '>', $logfile;


# Flags for signals that have been caught
my %caught;
$caught{'Alarm'} = 0;

while (1) {
    print "Sleeping 5\n";
    sleep 5;
    print "More sleeping\n";
    sleep 5;

    print "INT: ". $caught{'INT'} . " Alarm:" . $caught{'Alarm'} . "\n\n";

    # If we got SIGINT (2), and alarm is not yet set, set it!
    if ($caught{'INT'} == 1 && $caught{'Alarm'} != 1 ) {alarm(70); $caught{'Alarm'} = 1; };
}

# When we get a signal, set a flag in %caught
sub sigIntHandler {
	if ($caught{'INT'} == 1) {
    	print "INT caught!\n Alarm disabled \n" ;
    	$caught{'INT'} = 0;
    	alarm(0);
    	$caught{'Alarm'} = 0;
	}
	else {
		print "INT caught!\n Alarm enabled \n";
    	$caught{'INT'} = 1;
	}
}

# When we get a signal, set a flag in %caught
sub sigAlarmHandler {
    print "Alarm caught!\n";
    toggleSTD();
    mvLogFile($logfile);
    toggleSTD();
    print "i moved the logfile\n";
    $caught{'Alarm'} = 0;

}

sub toggleSTD {
	# logMode 
	if ($logMode eq "file"){
		$logMode = "term";
		print $logMode . " LOG MODE\n";
		close(STDOUT);
    	close(STDERR);

    	open(STDOUT, ">&OLDOUT");
    	open(STDERR, ">&OLDERR");

	}
	# logMode
	else {
		$logMode = "file";
		print $logMode . " LOG MODE\n";
		close(STDOUT);
    	close(STDERR);
		open(STDOUT, ">&OLDOUT");
    	open(STDERR, ">&OLDERR");
    	open STDOUT, '>', $logfile;
		open STDERR, '>', $logfile;
	}
}

sub mvLogFile {
	 my $logFile = shift;
	 my $tm=localtime; 
	 print $logFile . datePad($tm->hour) . ":" . datePad($tm->min) . "_". $tm->mday ."-" .  ($tm->mon+1) ."-". ($tm->year+1900) ."\n";
	 rename ($logFile, $logFile . datePad($tm->hour) . ":" . datePad($tm->min) . "_". $tm->mday ."-" .  ($tm->mon+1) ."-". ($tm->year+1900)) || print("Could not move File \n");
}

sub datePad {
	my $pad = shift;
	my $paddingSize = 2;
	if (length($pad) != $paddingSize) {$pad = "0" . $pad;}
	$pad;
}