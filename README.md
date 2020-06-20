# README

## Next up

## Later

Use `User.where("users.phone IN (?)", ["+19522015076", "+19522015077"])` kind of stuff to deal with Contacts upload checking.

## Notes

When changing a friendship we also need to update the corresponding DM's conversationMembership's profile. #denormalization

## Setup

`rvm install 2.6.3`
`rvm use 2.6.3`
`bundle`

I recommend installing https://postgresapp.com/

`rails db:create`
`rails db:migrate`
`rails db:seed`

`rails s`