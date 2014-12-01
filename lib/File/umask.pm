package File::umask;

use 5.010001;
use strict;
use warnings;

use POSIX qw();

use Exporter qw(import);
our @EXPORT = qw($UMASK);

# VERSION
# DATE

our $UMASK; tie $UMASK, 'File::umask::SCALAR' or die "Can't tie \$UMASK";

{
    package File::umask::SCALAR;

    sub TIESCALAR {
        bless [], $_[0];
    }

    sub FETCH {
        umask();
    }

    sub STORE {
        umask($_[1]);
    }
}

1;
#ABSTRACT: Get/set umask via (localizeable) variable

=head1 SYNOPSIS

 use File::umask;
 printf "Current umask is %03o", $UMASK; # -> 022
 {
     local $UMASK = 0;
     open my($fh), ">", "/tmp/foo"; # file created with 666 permission mode
 }
 open my($fh), ">", "/tmp/two"; # file created with normal 644 permission mode


=head1 DESCRIPTION

This module is inspired by L<File::chdir>, using a tied scalar variable to
get/set stuffs. One benefit of this is being able to use Perl's "local" with it,
effectively setting something locally.


=head1 EXPORTS

=head2 $UMASK (exported by default)


=head1 SEE ALSO

Perl's umask builtin.

L<Umask::Local>.

Other modules with the same concept: L<File::chdir>, L<Locale::Tie>,
L<Unix::setuid>.
