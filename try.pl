use logAndRotate;
use Data::Dumper;	
use strict;

#### Init block
#
# Copy the handles to preserve them for later switching
#
#keep original Filehandles
open(OLDOUT, ">&STDOUT");
open(OLDERR, ">&STDERR");
my $log = logAndRotate->new( {"logPath"=>"local.log", "fh"=>[{"fh"=>*STDOUT, "origFh" => *OLDOUT }, {"fh"=>*STDERR, "origFh" => *OLDERR }]  });
$SIG{ALRM} = sub {print "LLLLlLLL\n";$log->sigAlarmHandler;};

while (1){
	sleep 5;
	print "Yet a Line\n";
	print Dumper($log);
	sleep 6;

}