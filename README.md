# README

## Next up

## Later

Use `User.where("users.phone IN (?)", ["+19522015076", "+19522015077"])` kind of stuff to deal with Contacts upload checking.

## Notes

When changing a friendship we also need to update the corresponding DM's conversationMembership's profile. #denormalization

Kind of sad that we can use ActiveRecord:Enum to define the status colors because I nested it in a JSON object. Maybe we'll want
to break that object up into separate columns on Profile one day.

## Security

TODO: we need to limit access to ActionCable channels

## Running

`heroku local -f Procfile.dev`

## Setup

### Install Redis

`brew install redis`

`brew services start redis`

### Install libIDN

`brew install libidn`

### Install Heroku

`brew tap heroku/brew && brew install heroku`

### Install Ruby version

Consider using `asdf` instead of `rvm`.

`rvm install 2.6.3`

`rvm use 2.6.3`

### Install anycable-go

`brew install anycable-go`

### Install Postgres

I recommend installing https://postgresapp.com/

`bundle`

`bundle exec rails db:create`

`bundle exec rails db:migrate`

`bundle exec rails db:seed`

`heroku local`

## Typechecking with Sorbet

`bundle exec srb tc`
