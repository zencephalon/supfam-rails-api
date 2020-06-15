# README

## Next up

## Later

Use `User.where("users.phone IN (?)", ["+19522015076", "+19522015077"])` kind of stuff to deal with Contacts upload checking.

## Notes

I changed conversationMembership to use a last_message_index, but we need to change that back to a last_message_id. On the client side when receiving messages it's too much work to determine the count of each message, but we know the ID easily.

We'll compute the unread count on the server side, using a similar query to the message cursor. Just look for new messages in the conversation with id > the last read id.

Display unread status on conversations by just using a last_read_at timestamp

## Setup

`rvm install 2.6.3`
`rvm use 2.6.3`
`bundle`

I recommend installing https://postgresapp.com/

`rails db:create`
`rails db:migrate`
`rails db:seed`

`rails s`