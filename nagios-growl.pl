#!/usr/bin/perl -w
#
# Created by Mathieu Gagne 2009
# Updated by Guillaume Bisch, 2012
#

use strict;
use warnings;
use Growl::GNTP;
use Getopt::Long qw(:config no_ignore_case bundling);

# Default values
my $application = 'Nagios';
my $title = 'Alert';
my $message = '';
my $priority = 2;
my $sticky = 0;
my $destination = 'localhost';
my $password = '';

my $help = 0;

my $pod2usage = sub {
    # Load Pod::Usage only if needed.
    require "Pod/Usage.pm";
    import Pod::Usage;
    pod2usage(@_);
};

# Declare and retreive options
GetOptions(
    'h|help' => \$help,
    'a|application=s' => \$application,
    't|title=s' => \$title,
    'm|message=s' => \$message,
    'P|priority=i' => \$priority,
    's|sticky' => \$sticky,
    'H|host=s' => \$destination,
    'p|password=s' => \$password,
) or $pod2usage->(1);

# Print help
$pod2usage->(1) if $help;

# Validate options
if ( $application eq '' ) {
die "Error: Missing mandatory option: application\n";
}

if ( $title eq '' ) {
    die "Error: Missing mandatory option: title\n";
}

if ( $message eq '' ) {
    die "Error: Missing mandatory option: message\n";
}

if ( $priority eq '' ) {
    die "Error: Missing mandatory option: priority\n";
}

if ( $password eq '' ) {
    die "Error: Missing mandatory option: password\n";
}

#
# Main program
#

my $growl = Growl::GNTP->new(
    AppName => $application,
    PeerHost => $destination,
    Password => $password
);

# Register the application
$growl->register([
    { Name => $application, },
]);

# Send the notification
$growl->notify(
    Event => "Nagios",
    Title => $title,
    Message => $message,
    Icon => "",
    Priority => $priority,
    Sticky => $sticky
);