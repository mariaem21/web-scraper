README

How to get the web-scraping of the STUACT website to work locally.

1) You must open 2 terminals: one to run the app, and one to start the workers

1st terminal: rails server --binding=0.0.0.0
2nd terminal: bundle exec rake jobs:work

Troubleshooting delayed jobs

Here is the documentation: https://rubydoc.info/gems/delayed_job/2.1.4/frames

Some useful commands to try before diving into the documentation:
$ rake jobs:clear
- This command gets rid of all jobs in the table