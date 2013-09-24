 package logAndRotate;
 use strict;
 use Time::localtime;
 use Data::Dumper;
    ##################################################
    ## the object constructor ##
    ##################################################
    sub new {
        my($class) = shift;
        my($self) = {};
        my($params) = @_[0];


        $self->{"logPath"}   = $params->{"logPath"};
        my $rawHandles       = $params->{"fh"};
        $self->{"handles"}   = [];
        
        alarm(6);
        # SIG Handlers
        my $logMode = "file";

        foreach my $handle ( @$rawHandles )
        {
            my $test;
            #open $test, '>', $handle;
            push($self->{"handles"}, { "orignalHandle"=>  $test, "handle" => $handle});
        }
        print Dumper($self->{"handles"});

        # have them handles
        foreach my $handle ( @{$self->{"handles"} } )
        {
            open ${$handle}{'handle'}, '>', $self->{"logPath"};
        }


        bless($self);       # but see below
        return $self;
    }
    ##############################################
    ## methods to access per-object data        ##
    ##                                          ##
    ## With args, they set the value.  Without  ##
    ## any, they only retrieve it/them.         ##
    ##############################################

    sub logPath {
        my $self = shift;
        if (@_) { @{ $self->{"logPath"} } = @_ }
        return @{ $self->{"logPath"} };
    }

    sub handles {
        my $self = shift;
        return $self->{"handles"} ;
    }

    sub mvLogFile {
         my $self = shift;
         my $tm=localtime; 
         print $self->{"logPath"} . datePad($tm->hour) . ":" . datePad($tm->min) . "_". $tm->mday ."-" .  ($tm->mon+1) ."-". ($tm->year+1900) ."\n";
         rename ($self->{"logPath"}, $self->{"logPath"} . datePad($tm->hour) . ":" . datePad($tm->min) . "_". $tm->mday ."-" .  ($tm->mon+1) ."-". ($tm->year+1900)) || print("Could not move File \n");
    
    }

    sub sigAlarmHandler {
        print "Handler called!\n";
    }

    sub sigAlarm {
        my $self = shift;
        $self->{"sigAlarm"};
    }

    1;  # so the require or use succeeds
