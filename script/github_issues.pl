use strict;
use warnings FATAL => 'all';
use Pithub;
use Data::Dumper::Concise;
my $api_token = $ENV{GH_API_TOKEN} or die '$ENV{GH_API_TOKEN} required';

my $user = $ARGV[0];
my $repo = $ARGV[1];
my $pithub =
  Pithub->new( token => $api_token, user => $user, repo => $repo );
sub format_bug {
    my $issue = shift;
    return sprintf( "[ created by: %s ] [ assigned to: %s ] [ %s ]\n%s\n",
        $issue->{user}{login},
        ( $issue->{assignee} ? $issue->{assignee}{login} : "N/A" ),
        $issue->{title},
        $issue->{html_url} );
}
my $issues = $pithub->issues->list;
while( my $issue = $issues->next ) {
    print format_bug($issue);
}
