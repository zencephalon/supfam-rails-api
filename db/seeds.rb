# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

me = User.create(name: 'zen', password: 'password', password_confirmation: 'password', phone: '+19522015074' )
me_profile = me.create_profile(name: 'Matt')

mattfam_users_data = [{
    displayName: "Dad",
    displayImage: "https://justus-faces.s3.amazonaws.com/dad.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Donald Drumpf needs to go away",
    color: 2
  },
  {
    displayName: "Huff",
    displayImage: "https://justus-faces.s3.amazonaws.com/huff.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Groovin' to that funk",
    color: 1
  },
  {
    displayName: "Eleni",
    displayImage: "https://justus-faces.s3.amazonaws.com/eleni.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Heading to the get down",
    color: 2
  },
  {
    displayName: "Daria",
    displayImage: "https://justus-faces.s3.amazonaws.com/daria.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Doing jits",
    color: 0
  },
  {
    displayName: "Mark",
    displayImage: "https://justus-faces.s3.amazonaws.com/mark.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Any dinner plans?",
    color: 3
  },
  {
    displayName: "Mom",
    displayImage: "https://justus-faces.s3.amazonaws.com/mom.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Taking a walk",
    color: 2
  }
]

hf0_users_data = [
  {
    displayName: "Stedman",
    displayImage: "https://justus-faces.s3.amazonaws.com/stedman.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Just raised a $3 million seed round!",
    color: 1
  },
  {
    displayName: "Cathy",
    displayImage: "https://justus-faces.s3.amazonaws.com/cathy.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Crushing out some code",
    color: 1
  },
  {
    displayName: "DK",
    displayImage: "https://justus-faces.s3.amazonaws.com/dk.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Pushing a new version of Intention tonight",
    color: 2
  },
  {
    displayName: "Condon",
    displayImage: "https://justus-faces.s3.amazonaws.com/dk.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Have you tried boop lately?",
    color: 3
  },
  {
    displayName: "Hellyeah",
    displayImage: "https://justus-faces.s3.amazonaws.com/hellyeah.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Pink Roses just made the billboard top 100!",
    color: 2
  },
  {
    displayName: "Nivi",
    displayImage: "https://justus-faces.s3.amazonaws.com/nivi.png",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "At the gym! Thank god coronavirus ended",
    color: 0
  },
  {
    displayName: "Zain",
    displayImage: "https://justus-faces.s3.amazonaws.com/dk.jpg",
    phone: Faker::PhoneNumber.cell_phone_in_e164,
    statusText: "Try out the latest version of Relephant!",
    color: 2
  },
]

users_data.each do |data|
  user = User.new({ name: data[:displayName], avatar_url: data[:displayImage], password: 'password', password_confirmation: 'password' })
  user.save
  user.statuses.create({ message: data[:statusText], color: rand(4) })
  family.users << user
end