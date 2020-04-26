# typed: strict
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

me = User.create(name: 'zen', password: 'password', password_confirmation: 'password', phone: '+19522015074' )
me_profiles = [me.create_profile(name: 'Matt', avatar_key: "fixture/matt.jpg"), me.create_profile(name: 'Bunday', avatar_key: "fixture/matt.jpg")]

mattfam_users_data = [{
    displayName: "Dad",
    displayImage: "fixture/dad.jpg",
    statusText: "Donald Drumpf needs to go away",
    color: 2,
    phone: '+19522015075'
  },
  {
    displayName: "Huff",
    displayImage: "fixture/huff.jpg",
    statusText: "Groovin' to that funk",
    color: 1,
    phone: '+19522015076'
  },
  {
    displayName: "Eleni",
    displayImage: "fixture/eleni.jpg",
    statusText: "Heading to the get down",
    color: 2,
    phone: '+19522015077'
  },
  {
    displayName: "Daria",
    displayImage: "fixture/daria.jpg",
    statusText: "Doing jits",
    color: 0,
    phone: '+19522015078'
  },
  {
    displayName: "Mark",
    displayImage: "fixture/mark.jpg",
    statusText: "Any dinner plans?",
    color: 3,
    phone: '+19522015079'
  },
  {
    displayName: "Mom",
    displayImage: "fixture/mom.jpg",
    statusText: "Taking a walk",
    color: 2,
    phone: '+19522015080'
  }
]

hf0_users_data = [
  {
    displayName: "Stedman",
    displayImage: "fixture/stedman.jpg",
    statusText: "Just raised a $3 million seed round!",
    color: 1,
    phone: '+19522015081'
  },
  {
    displayName: "Cathy",
    displayImage: "fixture/cathy.jpg",
    statusText: "Crushing out some code",
    color: 1,
    phone: '+19522015081'
  },
  {
    displayName: "DK",
    displayImage: "fixture/dk.jpg",
    statusText: "Pushing a new version of Intention tonight",
    color: 2,
    phone: '+19522015082'
  },
  {
    displayName: "Condon",
    displayImage: "fixture/dk.jpg",
    statusText: "Have you tried boop lately?",
    color: 3,
    phone: '+19522015083'
  },
  {
    displayName: "Hellyeah",
    displayImage: "fixture/hellyeah.jpg",
    statusText: "Pink Roses just made the billboard top 100!",
    color: 2,
    phone: '+19522015084'
  },
  {
    displayName: "Nivi",
    displayImage: "fixture/nivi.png",
    statusText: "At the gym! Thank god coronavirus ended",
    color: 0,
    phone: '+19522015085'
  },
  {
    displayName: "Zain",
    displayImage: "fixture/dk.jpg",
    statusText: "Try out the latest version of Relephant!",
    color: 2,
    phone: '+19522015086'
  },
]

mattfam_users_data.each do |data|
  user = User.create({ password: 'password', password_confirmation: 'password', phone: data[:phone], name: data[:displayName] })
  profile = user.create_profile(avatar_key: data[:displayImage], name: data[:displayName])
  profile.update_status(message: data[:statusText], color: data[:color])
  me_profiles[0].create_friendship(profile.id)
end