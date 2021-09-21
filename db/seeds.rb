# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

puts "Deleting Runners"
Runner.delete_all

puts "Deleteing Races"
Race.delete_all

puts "Deleteing Users"
User.delete_all

puts "creating new Users"
users = []
5.times do
  first_name = Faker::Name.first_name
  middle_name = Faker::Name.middle_name
  users << User.create(
    name: "#{first_name} #{middle_name}",
    email: "#{first_name}@g.com",
    password: "12345678"
  )
  print "."
end
puts "5 Users created"

puts "Creating new Races"
15.times do
  a = Race.new(
    name: Faker::Superhero.name[0..24],
    description: Cicero.sentences(2),
    length: [2, 4, 6, 8, 12, 18, 22, 30, 42].sample,
    meet_point: Faker::Address.street_address,
    start_time: (Time.now() + rand(2_600_000..20_000_000)),
    public: [true, false].sample,
    user: users[rand(0...4)]
  )
  a.save!
  print "."
end
puts "15 Races created\n"

