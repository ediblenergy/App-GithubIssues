#!/usr/bin/env perl
use strict;
use warnings FATAL => 'all';
use utf8;
use Pithub;
use Data::Dumper::Concise;
use 5.14.0;
binmode( STDIN,  ":encoding(UTF-8)" );
binmode( STDOUT, ":encoding(UTF-8)" );
#copy-paste for now from github_issues.pl
sub format_bug {
    my $issue = shift;
    my @labels = map { "$_->{name}" } @{ $issue->{labels} };
    my $assigned = $issue->{assignee} ? $issue->{assignee}{login} : 'N/A';
    my $ret =  "[ $issue->{title} ]  [ assigned to: $assigned ]  [ created by: $issue->{user}{login} ] [ updated: $issue->{updated_at} ]"
        ."\n$issue->{html_url}\n";
    $ret .= "labels: ${\ join(',' => @labels ) }\n" if (@labels);
    $ret .= "\n";
}

my $api_token = $ENV{GH_API_TOKEN} or die '$ENV{GH_API_TOKEN} required';
my $ticket_prefix = `git config  --get core.ticketprefix`;
chomp($ticket_prefix);
unless ($ticket_prefix) {
    warn "Please set core.ticketprefix to use this commitmsg hook.", "\n",
      "git config --add  core.ticketprefix 'MyOrg/MyTicketRepo'";
    exit 0;
}
my ($user,$repo) = split(/\//,$ticket_prefix);
die "invalid user from $ticket_prefix" unless $user;
die "invalid repo from $ticket_prefix" unless $repo;
print "user:$user \t repo:$repo","\n";
my $pithub = Pithub->new( token => $api_token, user => $user, repo => $repo );
print "Issue title: ";
my $title = <STDIN>;
chomp($title);
print "\n";

my $issue = $pithub->issues->create(
    user => $user,
    repo => $repo,
    data => {
        title => $title,
    } );
print format_bug( $issue->content );
