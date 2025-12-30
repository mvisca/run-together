# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
require 'faker'
require 'open-uri'

addresses = [
  "Sagrada Familia, Barcelona, España",
  "Plaza del Sol, Madrid, España",
  "Parque del Retiro, Madrid, España",
  "Rambla, Tarragona, España",
  "Parque de María Luisa, Sevilla, España",
  "L'Hospitalet de Llobregat, Barcelona, España",
  "Santiago de Compostela, Galicia, España",
  "Torre Agbar, Barcelona, España",
  "Parque Güell, Barcelona, España",
  "Casa Batlló, Barcelona, España",
  "Plaza Mayor, Madrid, España",
  "Alhambra, Granada, España",
  "Catedral de Valencia, España",
  "Parque del Alamillo, Sevilla, España",
  "Montjuïc, Barcelona, España",
  "Ciudad de las Artes, Valencia, España",
  "Paseo de la Castellana, Madrid, España",
  "Playa de la Barceloneta, Barcelona, España"
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

profile_images = [
  { url: "https://res.cloudinary.com/dayvpa0ql/image/upload/v1767089187/ChatGPT_Image_30_dic_2025_10_59_07_lqsj9s.png", filename: "girl-solo.png" },
  { url: "https://res.cloudinary.com/dayvpa0ql/image/upload/v1767089185/ChatGPT_Image_30_dic_2025_11_04_08_sgjdso.png", filename: "man-solo.png" },
  { url: "https://res.cloudinary.com/dayvpa0ql/image/upload/v1767089183/ChatGPT_Image_30_dic_2025_11_04_14_xtra3l.png", filename: "group.png" },
  { url: "https://res.cloudinary.com/dayvpa0ql/image/upload/v1767089185/ChatGPT_Image_30_dic_2025_11_04_22_bpqcnr.png", filename: "man-laugh.png" },
  { url: "https://res.cloudinary.com/dayvpa0ql/image/upload/v1767089185/ChatGPT_Image_30_dic_2025_11_05_17_ch07aa.png", filename: "man-tv.png" }
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

puts "📸 Attaching profile photos..."
# Asignar imágenes a todos los usuarios excepto uno (Martin no tendrá foto)
users[1..-1].each_with_index do |user, index|
  # Usar las imágenes de forma cíclica si hay más usuarios que imágenes
  image = profile_images[index % profile_images.length]

  begin
    file = URI.open(image[:url])
    user.photo.attach(io: file, filename: image[:filename], content_type: 'image/png')
    puts "   ✓ Photo attached to #{user.name}: #{image[:filename]}"
  rescue => e
    puts "   ✗ Error attaching photo to #{user.name}: #{e.message}"
  end
end
puts "   ✓ Profile photos attached (#{users.count - 1} with photos, 1 without)\n\n"

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
  year = [2026, 2027].sample
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
  geocoded = race.geocoded? ? "📍" : "❌"
  coords = race.geocoded? ? "(#{race.latitude.round(4)}, #{race.longitude.round(4)})" : "No geocoded"
  puts "   #{visibility} #{geocoded} #{race.name} - #{race.length}km - #{runners_count} runners - #{coords}"
rescue ActiveRecord::RecordInvalid => e
  puts "   ✗ Error creating race: #{e.message}"
end

puts "   ✓ #{races_created} races created\n\n"

puts "📊 Summary:"
puts "   Users: #{User.count}"
puts "   Intros: #{Intro.count}"
puts "   Races: #{Race.count}"
puts "   Geocoded races: #{Race.geocoded.count}"
puts "   Runners: #{Runner.count}"
puts "\n✅ Seeds completed successfully!\n\n"
