README
Introduction
This is an application for scraping email addresses of student organizations from the TAMU STUACT website and exporting them to a downloadable CSV.

MUST USE CHROME

Requirements
This code has been run and tested on:

Environment - Docker (Latest Container) - Heroku v? - Nodejs - v16.9.1 - Yarn - 1.22.11 - Chrome

Program - Ruby - 3.0.2p107 - Rails - 6.1.4.1 - PostgreSQL - 13.3 - Ruby Gems - Listed in Gemfile

Tools - Git Hub - https://github.com/mariaem21/web-scraper - Jira

External Dependencies
Docker - Download latest version at https://www.docker.com/products/docker-desktop
Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli
Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
GitHub Desktop (Not needed, but HELPFUL) at https://desktop.github.com/
Documentation
Our product and sprint backlog can be found in Jira, with project name Wade

https://teamstams.atlassian.net/jira/software/projects/STAMS/boards/2

Installation
Download this code repository by using git:

git clone https://github.com/SP23-CSCE431/csce431-sprints-wade.git

Tests
An RSpec test suite is available and can be ran using:

rspec spec/

You can run all the test cases by running. This will run both the unit and integration tests. rspec .

Execute Code
1.) Open Powershell if using windows or the terminal using Linux/Mac

2.) Go to that directory where the web-scraper will reside (this is the directory that the git clone will put the app in)

3.) Download the code from Github and place in the preferred directory by doing the following:

git clone <repo name> Example: git clone https://github.com/mariaem21/web-scraper.git

---- If you have already cloned and would like to update the changes run the following

git stash (if you have any changes)

git pull origin test

4.) Create a docker container (if you haven't already)

make sure you are in the directory one above the directory where the code is

docker run -it --volume "${PWD}:/directory" -e DATABASE_USER=scraper_user -e DATABASE_PASSWORD=scraper_password -p 3000:3000 paulinewade/csce431:latest

*Note: directory is where the app code is located

-------If you want to re-enter an existing container, run the following: docker start -ai determined_dubinsky **determined_dubinsky is the name of the docker container

5.) bundle install

6.) If no database yet, run the following. rails db:create && rails db:migrate

If have existing database, do not run.

7.) Scrape student org from stuact (only if you need a fresh scrape)

Open a second powershell window

go to the directory where the code is

8.) and type in the following:

docker exec -it docker_container_name bash

*Note: docker_container_name bash is name of the container created above

This second powershell with the same docker container opened starts the scraping function

8.) Make sure you are still in the directory where the code is

9.) run this command in the second docker container:

bundle exec rake jobs:work

It should output the message "Starting job worker"

10.) Run the application in the first docker container that you made that is not running the scraping job

rails server --binding=0.0.0.0

11.) Open the application using a browser and navigate to http://localhost:3000/

12.) Click on "Update Site"

NOTE: This will start downloading from the stuact website. Please do not do anything or the download might not work.

Environmental Variables/Files
We have environment variables setup for Authentication. The tutorial can be found here: https://medium.com/craft-academy/encrypted-credentials-in-ruby-on-rails-9db1f36d8570

The tutorial above will help you understand now we encrypted the admin page's username and password!

Deployment
Setup a Heroku account: https://signup.heroku.com/

From the heroku dashboard select New -> Create New Pipline

Name the pipeline, and link the respective git repo to the pipline

Our application does not need any extra options, so select Enable Review Apps right away

Click New app under review apps, and link your test branch from your repo

Under staging app, select Create new app and link your main branch from your repo

To add enviornment variables to enable google oauth2 functionality, head over to the settings tab on the pipeline dashboard

Scroll down until Reveal config vars

Add both your client id and your secret id, with fields GOOGLE_OAUTH_CLIENT_ID and GOOGLE_OAUTH_CLIENT_SECRET respectively

Now once your pipeline has built the apps, select Open app to open the app

With the staging app, if you would like to move the app to production, click the two up and down arrows and select Move to production

And now your application is setup and in production mode!

CI/CD
Continuous Integration uses Github action to run rspec integration and feature tests that were created in the test driven development process.

Continuous Development is setup through Heroku which has been linked to our github repositories. Our Review application uses our test branch and our main branch hosts our final production application.

Support
The support of this app has been officially closed as the support team has been reassigned to other projects. No major features remain for development and any bugs are no longer responsibility of the dev team.

References
https://stackoverlfow.com https://chat.openai.com https://guides.rubyonrails.org/index.html

Extra Help
Please contact Tripper Wright tswright@tamu.edu with any questions about this application.