# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

matt_family = Family.create({name: 'mattfam'})
hf0_family = Family.create({name: 'hf0'})

mattfam_users_data = [{
    displayName: "Dad",
    displayImage: "https://justus-faces.s3.amazonaws.com/dad.jpg",
    statusText: "Donald Drumpf needs to go away",
    color: 2
  },
  {
    displayName: "Huff",
    displayImage: "https://justus-faces.s3.amazonaws.com/huff.jpg",
    statusText: "Groovin' to that funk",
    color: 1
  },
  {
    displayName: "Eleni",
    displayImage: "https://justus-faces.s3.amazonaws.com/eleni.jpg",
    statusText: "Heading to the get down",
    color: 2
  },
  {
    displayName: "Daria",
    displayImage: "https://justus-faces.s3.amazonaws.com/daria.jpg",
    statusText: "Doing jits",
    color: 0
  },
  {
    displayName: "Mark",
    displayImage: "https://justus-faces.s3.amazonaws.com/mark.jpg",
    statusText: "Any dinner plans?",
    color: 3
  },
  {
    displayName: "Mom",
    displayImage: "https://justus-faces.s3.amazonaws.com/mom.jpg",
    statusText: "Taking a walk",
    color: 2
  }
]

hf0_users_data = [
  {
    displayName: "Stedman",
    displayImage: "https://justus-faces.s3.amazonaws.com/stedman.jpg",
    statusText: "Just raised a $3 million seed round!",
    color: 1
  },
  {
    displayName: "Cathy",
    displayImage: "https://justus-faces.s3.amazonaws.com/cathy.jpg"
    statusText: "Crushing out some code",
    color: 1
  },
  {
    displayName: "DK",
    displayImage: "https://justus-faces.s3.amazonaws.com/dk.jpg"
    statusText: "Pushing a new version of Intention tonight",
    color: 2
  },
  {
    displayName: "Condon",
    displayImage: "https://justus-faces.s3.amazonaws.com/dk.jpg"
    statusText: "Have you tried boop lately?",
    color: 3
  },
  {
    displayName: "Hellyeah",
    displayImage: "https://justus-faces.s3.amazonaws.com/hellyeah.jpg"
    statusText: "Pink Roses just made the billboard top 100!",
    color: 2
  },
  {
    displayName: "Nivi",
    displayImage: "https://justus-faces.s3.amazonaws.com/nivi.png"
    statusText: "At the gym! Thank god coronavirus ended",
    color: 0
  },
  {
    displayName: "Zain",
    displayImage: "https://justus-faces.s3.amazonaws.com/dk.jpg"
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