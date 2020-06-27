# README

## Next up

## Later

Use `User.where("users.phone IN (?)", ["+19522015076", "+19522015077"])` kind of stuff to deal with Contacts upload checking.

## Notes

When changing a friendship we also need to update the corresponding DM's conversationMembership's profile. #denormalization

Kind of sad that we can use ActiveRecord:Enum to define the status colors because I nested it in a JSON object. Maybe we'll want
to break that object up into separate columns on Profile one day.

## Setup

Install Redis

`brew install redis`

`brew services start redis`

Install Heroku

`brew tap heroku/brew && brew install heroku`

Consider using `asdf` instead of `rvm`.

I recommend installing https://postgresapp.com/

`rvm install 2.6.3`

`rvm use 2.6.3`

`bundle`

`bundle exec rails db:create`

`bundle exec rails db:migrate`

`bundle exec rails db:seed`

`heroku local`