use logAndRotate;
use Data::Dumper;	
use strict;

my $log = logAndRotate->new( {"logPath"=>"local.log", "fh"=>[*STDOUT, *STDERR] } );

while (1){
	sleep 5;
print "hhhhhhhhhhhhhh";
print Dumper($log->handles())

	sleep 6;
}