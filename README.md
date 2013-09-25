#App::GithubIssues


##ABSTRACT

Github issue commit hook

##SYNOPSIS

      cd mygitrepo/
      ~/App-GithubIssues/script/install-github-issue-commit-msg
      git config --add  core.ticketprefix 'MyOrg/MyTicketRepo'
      git checkout -b ticket_123.testing_commit_hook
      echo "testing commit hook" > testing_commit_hook
      git add testing_commit_hook
      git commit -m "This commit message should be appended to https://github.com/MyOrg/MyTicketRepo/issues/123 with a link to this commit."
      git push origin HEAD

##DESCRIPTION

create a branch which matches /ticket[-|_](\d+)\./, and every commit message will have
a link to that ticket appended to it, unless there already is one, 
ex: if your message includes "Fixes MyOrg/MyTicketRepo#123"
