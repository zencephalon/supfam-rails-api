# typed: true
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
    userName: 'matt',
    displayName: "Matt Bunday",
    displayImage: "fixture/matt.jpg",
    statusText: "Growing Supfam!",
    color: 1,
    phone: '+19522015074'
  },
  # {
  #   displayName: "Dad",
  #   displayImage: "fixture/dad.jpg",
  #   statusText: "Donald Drumpf needs to go away",
  #   color: 2,
  #   phone: '+19522003146'
  # },
  {
    userName: 'huff',
    displayName: "Matt Huff",
    displayImage: "fixture/huff.jpg",
    statusText: "Groovin' to that funk",
    color: 0,
    phone: '+19522015076'
  },
  { 
    userName: 'evan',
    displayName: "Evan Stites-Clayton",
    displayImage: "fixture/evan.jpg",
    statusText: "Working on newDay",
    color: 0,
    phone: '+15103883187'
  },
  # {
  #   displayName: "Eleni",
  #   displayImage: "fixture/eleni.jpg",
  #   statusText: "Castle soiree crew gather!",
  #   color: 3,
  #   phone: '+19522015077'
  # },
  {
    userName: 'daria',
    displayName: "Daria Jung",
    displayImage: "fixture/daria.jpg",
    statusText: "Training bjj",
    color: 0,
    phone: '+19172470014'
  },
  {
    userName: 'mark',
    displayName: "Mark Bunday",
    displayImage: "fixture/mark.jpg",
    statusText: "Protesting #justiceforgeorge",
    color: 1,
    phone: '+16127353148'
  },
  {
    userName: 'grace',
    displayName: "Grace Bunday",
    displayImage: "fixture/mom.jpg",
    statusText: "Taking a walk",
    color: 2,
    phone: '+19522003147'
  },
  {
    userName: 'stedman',
    displayName: "Stedman Blake Hood",
    displayImage: "fixture/stedman.jpg",
    statusText: "Just raised a $1.5 million seed round!",
    color: 1,
    phone: '+19522015000'
  },
  {
    userName: 'cathy',
    displayName: "Cathy Chen",
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
    userName: 'condon',
    displayName: "Matt Condon",
    displayImage: "fixture/condon.jpg",
    statusText: "案ずるより産むが易し",
    color: 3,
    phone: '+19522015083'
  },
  {
    userName: 'dave',
    displayName: "Dave Hellyeah",
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

def get_random_location
  { "latitude" => 40.6749728 + rand() * 0.01, "longitude" => -73.9434645 + rand() * 0.01}
end

mattfam_users_data.map.with_index do |data, index|
  puts data
  user = User.create({ password: 'password', password_confirmation: 'password', phone: data[:phone], name: data[:userName] })
  user.save!
  profile = user.create_profile(avatar_key: data[:displayImage], name: data[:displayName])
  profile.update_status(message: data[:statusText], color: data[:color])
  profile.update_seen(get_random_seen, DateTime.now() - ((10-index)*60*4).seconds)
  profile.update_location(get_random_location, DateTime.now() - rand(150).seconds)
  profile
end.combination(2) do |pair|
  # next if rand() > 0.5
  pair[0].create_friendship(pair[1].id)
  puts "Pair #{pair[0].id} #{pair[1].id}"
end

dm = Conversation.find_by(dmId: "1:9")
dm.add_message(9, {message: "Let's stop by Mark's place on the way back from ramen?"})
group_chat = Conversation.create({ name: 'Party planning'})
group_chat.add_conversation_members_by_profile_ids([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
group_chat.add_message(2, { message: "We got a huge outdoor space for this"})
group_chat = Conversation.create({ name: 'My peeps'})
group_chat.add_conversation_members_by_profile_ids([1, 2, 3])
group_chat.add_message(2, { message: "Want to grab ramen in like 45 minutes?"})
