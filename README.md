# Metadata From API Specification

This is a proof of concept application that searches Github for API specification
files within government department Github repositories. It then tries to extract
metadata from the API specification documents.

## Retrieving data

Gathering the data comprises three steps:

- `Organisation.populate` will create a set of organisations where
  each organisation represents a government department's github presence.
- `organisation.find_and_create_records` will search the organisation's github
  applications for API Specification documents and create a record for each one
  it finds.
- `record.process` will get the contents of the documents identified in the
  previous step, and attempt to generate a metadata record from the document.

## The web page views.

The application is set up to display all the UK Government organisations it
finds.

The page for a particular organisation will list the records that it has been
able to extract metadata from. There is also an update button on this page that
can be used to initiate a data gathering process (as detailed above) for this
organisation.

## Local installation
This is a Ruby on Rails application and requires Ruby and PostgesSQL installed.

- Clone this application to your local environment
- cd into the application root
- run `bundle` to install the required ruby gems
- run `rails db:create` and `rails schema:load` to set up the database
- run `rake javascript:build` to set up the JavaScript environment
- run `rake dartsass:build` to set up SASS

You should then be able to run a local instance of the application using `rails s`

### Credentials

The system requires a Github key to be provide. This allows the search for
content on github to function. To work either:

- Set the environment variable `GITHUB_KEY` to return a Github key
- In development, set the credentials to include `github_key` with the Github key.

## Continual Integration (CI)
The CI pipeline for this application are run via github actions.

The following CI elements can be run locally before deployment.

### Tests
To run the test locally use the command `rspec`

### Linting
Use Rubocop to check the Ruby code of this application locally. The following
command will both find any problems and attempt to fix them: `rubocop -A`

### Vulnerability testing
Use the command `brakeman` to locally run a vulnerability test on the code
