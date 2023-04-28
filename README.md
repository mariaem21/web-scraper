# README

## Introduction

This is an application for scraping email addresses of student organizations from the TAMU STUACT website and exporting them to a downloadable CSV. 

## Requirements

This code has been run and tested on:

Environment
- Docker (Latest Container)
•	Heroku v?
- Nodejs - v16.9.1
- Yarn - 1.22.11

Program
- Ruby - 3.0.2p107
- Rails - 6.1.4.1
- PostgreSQL - 13.3
- Ruby Gems - Listed in `Gemfile`

Tools
- Git Hub - `https://github.com/mariaem21/web-scraper`
- Jira

## External Deps

- Docker - Download latest version at https://www.docker.com/products/docker-desktop
- Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
- Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- GitHub Desktop (Not needed, but HELPFUL) at https://desktop.github.com/

## Documentation

Our product and sprint backlog can be found in Jira, with project name Wade

`https://teamstams.atlassian.net/jira/software/projects/STAMS/boards/2`

## Installation

Download this code repository by using git:

`git clone https://github.com/SP23-CSCE431/csce431-sprints-wade.git`


## Tests

An RSpec test suite is available and can be ran using:

`rspec spec/`

You can run all the test cases by running. This will run both the unit and integration tests.
`rspec .`

## Execute Code

Run the following code in Powershell if using windows or the terminal using Linux/Mac

download the code from Github and place in the preferred directory

You can do it using

git clone 

------------------- If you have already cloned and would like to update the changes run the following

git stash (if you have any changes)

git pull origin test

------------------- Now create a docker container (if you haven't alread)

docker run --rm -it --volume "${PWD}:/directory" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest

*Note: directory is where the app code is located

bundle install

rails db:create && rails db:migrate

------------------- Run the following only if I need to do a fresh scrape

Open other powershell window and type in the following:

docker exec -it docker_container bash

*Note: docker_container is name of the container created above

Open second docker container to start workers for scraping function, only when you need to scrape

run this command in the second docker container: 

bundle exec rake jobs:work

It should output the message "Starting job worker"

------------------- This is to run the program, make sure to do this one a docker container that you made that is not running the jobs (if you are trying to scrape)

Run the app rails server --binding:0.0.0.0

The application can be seen using a browser and navigating to http://localhost:3000/


## Environmental Variables/Files

We have environment variables setup for Authentication. The tutorial can be found here: https://medium.com/craft-academy/encrypted-credentials-in-ruby-on-rails-9db1f36d8570

The tutorial above will help you understand now we encrypted the admin page's username and password!


## Deployment

Setup a Heroku account: https://signup.heroku.com/

From the heroku dashboard select `New` -> `Create New Pipline`

Name the pipeline, and link the respective git repo to the pipline

Our application does not need any extra options, so select `Enable Review Apps` right away

Click `New app` under review apps, and link your test branch from your repo

Under staging app, select `Create new app` and link your main branch from your repo

--------

To add enviornment variables to enable google oauth2 functionality, head over to the settings tab on the pipeline dashboard

Scroll down until `Reveal config vars`

Add both your client id and your secret id, with fields `GOOGLE_OAUTH_CLIENT_ID` and `GOOGLE_OAUTH_CLIENT_SECRET` respectively

Now once your pipeline has built the apps, select `Open app` to open the app

With the staging app, if you would like to move the app to production, click the two up and down arrows and select `Move to production`

And now your application is setup and in production mode!

## CI/CD

Continuous Integration uses Github action to run rspec integration and feature tests that were created in the test driven development process.

Continuous Development is setup through Heroku which has been linked to our github repositories. Our Review application uses our test branch and our main branch hosts our final production application.

## Support

The support of this app has been officially closed as the support team has been reassigned to other projects. No major features remain for development and any bugs are no longer responsibility of the dev team.

## Extra Helps

Please contact Tripper Wright tswright@tamu.edu with any questions about this application.
