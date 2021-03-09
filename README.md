# CCS CONCLAVE DOCUMENT UPLOAD SERVICE
This is the Check service which is part of the Conclave Document Upload Services

## Nomenclature

- **Client**: used for basic token authentication. For each application that can post to this service, a Client object needs to be created
- **Document**: used to store the state of the file and to be used to retrieve the file once threat scanning succeeds
- **UncheckedDocument**: used to store the file initially, until the threat scanning is run. This is also the object that gets passed through to the Checker service to run threat scanning

## Technical documentation

This is a Ruby on Rails application that takes a unchecked_document_id and runs threat scanning on the attached document_file. It's only presented as an internal API and doesn't face public users.

### Setup instructions
#### For OSX/macOS version 10.9 or higher

##### 1. Install command line tools on terminal

`xcode-select --install`

##### 2. Install Hombrew

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

##### 3. Install rbenv

`brew update`
`brew install rbenv`
`echo 'eval "$(rbenv init -)"' >> ~/.bash_profile`
`source ~/.bash_profile`

##### 4. Build ruby 2.7.2 with rbenv

`rbenv install 2.7.2`
`rbenv global 2.7.2`

##### 5. Install rails 6.0.3

`gem install rails -v 6.0.3`

##### 6. Download and install Postgresql 10

Go to https://www.postgresql.org/ and download the installer

##### 7. Install redis

`brew install redis`

##### 8. Create and migrate the database

`rake db:create && rake db:migrate`

##### 9. Setup ClamAV, freshclam and run clamd

Setup instructions can be found here: https://www.clamav.net/documents/installing-clamav

To run clamd:

`/usr/local/sbin/clamd --foreground=yes`

### Running the application

From your console run redis-server, sidekiq and the rails server:
`redis-server`
`bundle exec sidekiq -C config/sidekiq.yml`
`bundle exec sidekiq -C config/sidekiq-small-files.yml`
`rails s`

You can now use the service by sending a PUT request to: `localhost:3000/document-check`

### Running the test suite

To run the specs, from your console do:
`rspec spec`
