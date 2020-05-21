# README

## Next up

## Later

Use `User.where("users.phone IN (?)", ["+19522015076", "+19522015077"])` kind of stuff to deal with Contacts upload checking.

## Notes

I changed conversationMembership to use a last_message_index, but we need to change that back to a last_message_id. On the client side when receiving messages it's too much work to determine the count of each message, but we know the ID easily.

We'll compute the unread count on the server side, using a similar query to the message cursor. Just look for new messages in the conversation with id > the last read id.

## Archive

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
