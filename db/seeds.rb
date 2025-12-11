# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'faker'

addresses = [
  "Sagrada Familia, Barcelona",
  "Plaza del Sol, Madrid",
  "Parque del Retiro, Madrid",
  "Rambla, Tarragona",
  "Parque de María Luisa, Sevilla",
  "L'Hospitalet de Llobregat, Barcelona",
  "Santiago de Compostela, Galicia",
  "Torre Agbar, Barcelona",
  "Parque Güell, Barcelona",
  "Casa Batlló, Barcelona",
  "Plaza Mayor, Madrid",
  "Alhambra, Granada",
  "Catedral de Valencia",
  "Parque del Alamillo, Sevilla",
  "Montjuïc, Barcelona",
  "Ciudad de las Artes, Valencia",
  "Paseo de la Castellana, Madrid",
  "Playa de la Barceloneta, Barcelona"
]

race_names = [
  "Carrera Matinal",
  "Trail Urbano",
  "Running Social",
  "Ruta del Amanecer",
  "Carrera Verde",
  "Sprint Nocturno",
  "Maratón Express",
  "Ruta Costera",
  "Trail de Montaña",
  "Carrera del Parque",
  "Running Friends",
  "Ruta Histórica",
  "Carrera Solidaria",
  "Trail Challenge",
  "Running Weekend"
]

puts "\n🗑️  Cleaning database..."
puts "   Deleting Runners..."
Runner.delete_all
puts "   Deleting Races..."
Race.delete_all
puts "   Deleting Intros..."
Intro.delete_all
puts "   Deleting Users..."
User.delete_all
puts "   ✓ Database cleaned\n\n"

puts "👤 Creating users..."
users = []

# Martin's user
users << User.create!(
  name: 'Martin',
  email: 'm@m.m',
  password: '111111'
)
puts "   ✓ Created: Martin (m@m.m)"

# Additional users
user_names = [
  "Carlos García",
  "Laura Martínez",
  "David López",
  "Ana Rodríguez",
  "Pablo Sánchez",
  "María González",
  "Jorge Fernández",
  "Sara Torres"
]

user_names.each do |name|
  first_name = name.split.first.downcase
  user = User.create!(
    name: name,
    email: "#{first_name}@runner.com",
    password: "123456"
  )
  users << user
  puts "   ✓ Created: #{name} (#{first_name}@runner.com)"
end

puts "   ✓ #{users.count} users created\n\n"

puts "📝 Creating intros..."
users.each do |user|
  intro_text = Faker::Lorem.paragraph(sentence_count: 2)[0..219]
  Intro.create!(
    user: user,
    about: intro_text
  )
  puts "   ✓ Intro for #{user.name}"
end
puts "   ✓ #{users.count} intros created\n\n"

puts "🏃 Creating races..."
races_created = 0

race_names.each_with_index do |race_name, index|
  # Create races with dates in 2025-2026
  year = [2025, 2026].sample
  month = (1..12).to_a.sample
  day = (1..28).to_a.sample
  hour = [8, 9, 10, 17, 18, 19, 20].sample
  minute = [0, 15, 30, 45].sample

  race = Race.create!(
    name: race_name,
    description: Cicero.sentences(2),
    length: [3, 5, 7, 10, 15, 21].sample,
    meet_point: addresses.sample,
    start_date: DateTime.new(year, month, day, hour, minute),
    public: index < 12, # First 12 are public, last 3 private
    user: users.sample
  )

  # Add the race creator as a runner
  Runner.create!(
    user: race.user,
    race: race
  )

  # Add 2-5 additional random runners to each race
  additional_runners = rand(2..5)
  available_users = users.reject { |u| u.id == race.user_id }

  additional_runners.times do
    next_user = available_users.sample
    Runner.create!(
      user: next_user,
      race: race
    ) if next_user && !race.runners.exists?(user_id: next_user.id)
  end

  races_created += 1
  runners_count = race.runners.count
  visibility = race.public? ? "🌍" : "🔒"
  puts "   #{visibility} #{race.name} - #{race.length}km - #{runners_count} runners"
rescue ActiveRecord::RecordInvalid => e
  puts "   ✗ Error creating race: #{e.message}"
end

puts "   ✓ #{races_created} races created\n\n"

puts "📊 Summary:"
puts "   Users: #{User.count}"
puts "   Intros: #{Intro.count}"
puts "   Races: #{Race.count}"
puts "   Runners: #{Runner.count}"
puts "\n✅ Seeds completed successfully!\n\n"
