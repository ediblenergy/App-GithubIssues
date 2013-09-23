use strict;
use warnings FATAL => 'all';
use Pithub;
use Data::Dumper::Concise;
my $usage = "$0 <ORGANIZATION> <REPO> <TEAM> [TEAM]...";
my $api_token = $ENV{GH_API_TOKEN} or die '$ENV{GH_API_TOKEN} required';

my $organization = shift(@ARGV) or die $usage;
my $repo         = shift(@ARGV) or die $usage;

my $pithub = Pithub->new( token => $api_token );
#my $sf_org = $pithub->orgs->get( org => $organization );  
my @teams = @ARGV;
die $usage unless @teams;
#my $members = $pithub->orgs->members->list( org => $organization );
my $teams = $pithub->orgs->teams->list( org => $organization );
my %team;
while (my $t = $teams->next ) {
    $team{$t->{name}} = $t->{id};
}

sub _all {
    my $result = shift;
    my @ret;
    while( my $item = $result->next ) {
        push(@ret,$item);
    }
    return \@ret;
}
sub _parse_issues {
    for ( @{ _all(shift) } ) {
        print( format_bug($_) );
    }
}
sub _parse_members {
    my $members = shift;
    while ( my $member = $members->next ) {
        _parse_issues(
            $pithub->issues->list(
                user   => $organization,
                repo   => $repo,
                params => { assignee => $member->{login} } ) );
    }
}
sub _parse_team {
    my $t = shift;
    _parse_members(
        $pithub->orgs->teams->list_members(
            org     => $organization,
            team_id => $team{$_},
        ) );
}
_parse_team($_) for @teams;
#
#my %team = map { } vv
sub format_bug {
    my $issue = shift;
    my @labels = map { "$_->{name}" } @{ $issue->{labels} };
    my $assigned = $issue->{assignee} ? $issue->{assignee}{login} : 'N/A';
    my $ret =  "[ $issue->{title} ]  [ assigned to: $assigned ]  [ created by: $issue->{user}{login} ]"
        ."\n$issue->{html_url}\n";
    $ret .= "labels: ${\ join(',' => @labels ) }\n" if (@labels);
    $ret .= "\n";
}
#my $issues = $pithub->issues->list;
#while( my $issue = $issues->next ) {
#    print format_bug($issue);
#}
#
