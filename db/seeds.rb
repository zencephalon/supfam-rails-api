# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

family = Family.create({name: 'mattfam'})

users_data = [{
    displayName: "Dad",
    displayImage: "https://justus-faces.s3.amazonaws.com/dad.jpg",
    statusText: "Donald Drumpf needs to go away",
  },
  {
    displayName: "Huff",
    displayImage: "https://justus-faces.s3.amazonaws.com/huff.jpg",
    statusText: "Groovin' to that funk",
  },
  {
    displayName: "Eleni",
    displayImage: "https://justus-faces.s3.amazonaws.com/eleni.jpg",
    statusText: "Anyone seen the new contrapoints?",
  },
  {
    displayName: "Daria",
    displayImage: "https://justus-faces.s3.amazonaws.com/daria.jpg",
    statusText: "Doing jits",
  },
  {
    displayName: "Mark",
    displayImage: "https://justus-faces.s3.amazonaws.com/mark.jpg",
    statusText: "Any dinner plans?",
  },
  {
    displayName: "Stedman",
    displayImage: "https://justus-faces.s3.amazonaws.com/stedman.jpg",
    statusText: "Working in The Salon chez Stedman",
  },
  {
    displayName: "Mom",
    displayImage: "https://justus-faces.s3.amazonaws.com/mom.jpg",
    statusText: "Taking a walk",
  }
]

users_data.each do |data|
  user = User.new({ name: data[:displayName], avatar_url: data[:displayImage], password: 'password', password_confirmation: 'password' })
  user.save
  user.statuses.create({ message: data[:statusText], color: rand(4) })
  family.users << user
end