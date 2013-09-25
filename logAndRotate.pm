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
        $self->{"handles"}   = $params->{"fh"};
        $self->{"interval"}  = $params->{"interval"} || 60;#*60*24;
        print Dumper($params->{'fh'});

        # start alarm
        alarm($self->{"interval"});

        # set to FH to file handler
        $self->{"logMode"} = "file";

        # have them handles 
        foreach my $handle ( @{$self->{"handles"} } )
        {
            open ${$handle}{'fh'}, '>', $self->{"logPath"};
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


    sub mvLogFile {
         my $self = shift;
         my $tm=localtime; 
         print $self->{"logPath"} . datePad($tm->hour) . ":" . datePad($tm->min) . "_". $tm->mday ."-" .  ($tm->mon+1) ."-". ($tm->year+1900) ."\n";
         rename ($self->{"logPath"}, $self->{"logPath"} . datePad($tm->hour) . ":" . datePad($tm->min) . "_". $tm->mday ."-" .  ($tm->mon+1) ."-". ($tm->year+1900)) || print("Could not move File \n");
    
    }

    sub sigAlarmHandler {
        my $self = shift;
        print "Handler called!\n";
        # switch to Terminal Output
        $self->toggleOutput;
        $self->mvLogFile;
        # switch to Terminal Output
        $self->toggleOutput;
        # set next alarm
        alarm($self->{"interval"});
    }

    sub toggleOutput{
        my $self = shift;

        if ( $self->{"logMode"} eq "file"){
            $self->{"logMode"} = "term";
            print  $self->{"logMode"} . " LOG MODE\n";
            foreach my $handle ( @{$self->{"handles"} } ){
                close(${$handle}{'fh'});
                open(${$handle}{'fh'}, ">&", ${$handle}{'origFh'});
            }
        }
        # logMode
        else { 
            $self->{"logMode"} = "file";
            print  $self->{"logMode"} . " LOG MODE\n";
            foreach my $handle ( @{$self->{"handles"} } ) {
                close(${$handle}{'fh'});
                open(${$handle}{'fh'}, ">&", ${$handle}{'origFh'});
                open(${$handle}{'fh'}, ">", $self->{"logFile"});
            }
    }
    sub datePad {
            my $pad = shift;
            my $paddingSize = 2;
            if (length($pad) != $paddingSize) {$pad = "0" . $pad;}
            $pad;
        }
}

1;  # so the require or use succeeds
