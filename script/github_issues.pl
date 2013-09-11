use strict;
use warnings FATAL => 'all';
use Pithub;
use Data::Dumper::Concise;
my $api_token = $ENV{GH_API_TOKEN} or die '$ENV{GH_API_TOKEN} required';
my $pithub = Pithub->new( token => $api_token );
sub format_bug {
    my $issue = shift;
    return sprintf( "[ %s ] [ %s ]\n%s\n", $issue->{state}, $issue->{title}, $issue->{html_url} );
}
my $issues = $pithub->issues->list;
while( my $issue = $issues->next ) {
    print format_bug($issue);
}
