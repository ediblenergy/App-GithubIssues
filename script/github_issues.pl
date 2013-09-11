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
    my @labels = map { "$_->{name}" } @{ $issue->{labels} };
    my $assigned = $issue->{assignee} ? $issue->{assignee}{login} : 'N/A';
    my $ret =  "[ $issue->{title} ]  [ assigned to: $assigned ]  [ created by: $issue->{user}{login} ]"
        ."\n$issue->{html_url}\n";
    $ret .= "labels: ${\ join(',' => @labels ) }\n" if (@labels);
    $ret .= "\n";
}
my $issues = $pithub->issues->list;
while( my $issue = $issues->next ) {
    print format_bug($issue);
}
