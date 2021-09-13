# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

puts "Deleteing Races"
Race.delete_all

puts "Creating new Races"
15.times do
  Race.create(
    name: Faker::Superhero.name,
    description: Cicero.sentences(4),
    length: [2, 4, 6, 8, 12, 18, 22, 30, 42].sample,
    meet_point: Faker::Address.street_address,
    race_datetime: (Time.now() + rand(2_600_000..20_000_000))
  )
  print "."
end
puts "15 Races created\n"

