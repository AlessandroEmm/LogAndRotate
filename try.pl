use logAndRotate;
use Data::Dumper;	
use strict;

my $log = logAndRotate->new( {"logPath"=>"local.log", "fh"=>[*STDOUT, *STDERR] });
$SIG{ALRM} = sub {print "LLLLlLLL\n";$log->sigAlarmHandler; alarm(60)};

while (1){
	sleep 5;
	print "hhhhhhhhhhhhhh\n";
	#print Dumper($log);
	sleep 6;
}