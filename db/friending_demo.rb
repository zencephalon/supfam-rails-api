# typed: strict
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# me = User.create(name: 'zen', password: 'password', password_confirmation: 'password', phone: '+19522015074' )
# me_profiles = [me.create_profile(name: 'Matt', avatar_key: "fixture/matt.jpg"), me.create_profile(name: 'Bunday', avatar_key: "fixture/matt.jpg")]

mattfam_users_data = [
  {
    displayName: "Daria",
    displayImage: "fixture/daria.jpg",
    statusText: "Training bjj",
    color: 0,
    phone: '+19172470014'
  },
  {
    displayName: "Matt",
    displayImage: "fixture/matt.jpg",
    statusText: "Growing Supfam!",
    color: 1,
    phone: '+19522015074'
  },
  { displayName: "Evan",
    displayImage: "fixture/evan.jpg",
    statusText: "Working on newDay",
    color: 0,
    phone: '+15103883187'
  },
  # {
  #   displayName: "Dad",
  #   displayImage: "fixture/dad.jpg",
  #   statusText: "Donald Drumpf needs to go away",
  #   color: 2,
  #   phone: '+19522003146'
  # },
  {
    displayName: "Huff",
    displayImage: "fixture/huff.jpg",
    statusText: "Groovin' to that funk",
    color: 0,
    phone: '+19522015076'
  },

  # {
  #   displayName: "Eleni",
  #   displayImage: "fixture/eleni.jpg",
  #   statusText: "Castle soiree crew gather!",
  #   color: 3,
  #   phone: '+19522015077'
  # },

  {
    displayName: "Mark",
    displayImage: "fixture/mark.jpg",
    statusText: "Protesting #justiceforgeorge",
    color: 1,
    phone: '+16127353148'
  },
  {
    displayName: "Grace",
    displayImage: "fixture/mom.jpg",
    statusText: "Taking a walk",
    color: 2,
    phone: '+19522003147'
  },
  {
    displayName: "Stedman",
    displayImage: "fixture/stedman.jpg",
    statusText: "Just raised a $1.5 million seed round!",
    color: 1,
    phone: '+19522015000'
  },
  {
    displayName: "Cathy",
    displayImage: "fixture/cathy.jpg",
    statusText: "Playing trumpet and open to jamz",
    color: 2,
    phone: '+19522015081'
  },
  # {
  #   displayName: "DK",
  #   displayImage: "fixture/dk.png",
  #   statusText: "Pushing a new version of Intention tonight",
  #   color: 2,
  #   phone: '+19522015082'
  # },
  {
    displayName: "Condon",
    displayImage: "fixture/condon.jpg",
    statusText: "案ずるより産むが易し",
    color: 3,
    phone: '+19522015083'
  },
  {
    displayName: "Dave",
    displayImage: "fixture/hellyeah.jpg",
    statusText: "Pink Roses just made the billboard top 100!",
    color: 3,
    phone: '+19522015084'
  }
  # {
  #   displayName: "Nivi",
  #   displayImage: "fixture/nivi.png",
  #   statusText: "At the gym! Thank god coronavirus ended",
  #   color: 0,
  #   phone: '+19522015085'
  # },
  # {
  #   displayName: "Zain",
  #   displayImage: "fixture/zain.jpg",
  #   statusText: "Try out the latest version of Relephant!",
  #   color: 2,
  #   phone: '+19522015086'
  # }
]

puts mattfam_users_data.size

def get_random_seen
  {"battery_state" => rand(1..2), "battery" => rand(), "network_type" => ['wifi', 'cellular'].sample, "network_strength" => rand(1..5)}
end

mattfam_users_data.map do |data|
  puts data
  user = User.create({ password: 'password', password_confirmation: 'password', phone: data[:phone], name: data[:displayName] })
  user.save!
  profile = user.create_profile(avatar_key: data[:displayImage], name: data[:displayName])
  profile.update_status(message: data[:statusText], color: data[:color])
  profile.update_seen(get_random_seen, DateTime.now() - rand(150).seconds)
  profile
end

daria = Profile.find(1)

(2..9).each do |profile_id|
  daria.create_friendship(profile_id)
end

Conversation.create({ name: 'HF0 Demo Group Chat'})