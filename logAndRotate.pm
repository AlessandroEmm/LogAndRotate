 package logAndRotate;
 use strict;
 use Time::localtime;

    ##################################################
    ## constructor 
    ##################################################
    sub new {
        my($class) = shift;
        my($self) = {};
        my($params) = @_[0];

        
        $self->{"logPath"}   = $params->{"logPath"};
        $self->{"handles"}   = $params->{"fh"};
        $self->{"interval"}  = $params->{"interval"} || 60;#*60*24;

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
    ## Methods
    ##############################################

    sub logPath {
        my $self = shift;
        if (@_) { @{ $self->{"logPath"} } = @_ }
        return @{ $self->{"logPath"} };
    }

    sub __mvLogFile {
         my $self = shift;
         my $tm=localtime; 
         rename ($self->{"logPath"}, $self->{"logPath"} . "." . __datePad($tm->hour) . ":" . __datePad($tm->min) . "_". $tm->mday ."-" .  ($tm->mon+1) ."-". ($tm->year+1900)) || print("Could not move File \n");
    
    }

    sub sigAlarmHandler {
        my $self = shift;
        # switch to Terminal Output
        $self->__toggleOutput;
        $self->__mvLogFile;
        # switch to Terminal Output
        $self->__toggleOutput;
        # set next alarm
        alarm($self->{"interval"});
    }

    sub __toggleOutput{
        my $self = shift;

        if ( $self->{"logMode"} eq "file"){
            $self->{"logMode"} = "term";
            foreach my $handle ( @{$self->{"handles"} } ){
                close(${$handle}{'fh'});
                open(${$handle}{'fh'}, ">&", ${$handle}{'origFh'});
            }
        }
        else { 
            $self->{"logMode"} = "file";
            foreach my $handle ( @{$self->{"handles"} } ) {
                close(${$handle}{'fh'});
                open(${$handle}{'fh'}, ">&", ${$handle}{'origFh'});
                open(${$handle}{'fh'}, ">",  $self->{"logPath"});
            }
    }

    sub __datePad {
            my $pad = shift;
            if (length($pad) == 1) {"0" . $pad;}
            else { $pad; }
    }
}

1;  # so the require or use succeeds
