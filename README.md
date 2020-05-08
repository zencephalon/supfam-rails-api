# README

## Next up

Have messages#send_message_to_profile take a `cursor` param.

Add a method to the conversation model to grab messages based on the cursor.

`c.messages.where("messages.id > 0").order(id: :desc).limit(3)`

We can get pagination with infinite scroll going.

## Later

Use `User.where("users.phone IN (?)", ["+19522015076", "+19522015077"])` kind of stuff to deal with Contacts upload checking.

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
