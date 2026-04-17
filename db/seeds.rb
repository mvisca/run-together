require 'faker'
require 'open-uri'

# ============================================
# MODO DE SEEDS
# ============================================
seed_mode = ENV['SEED_MODE'] || 'normal'

puts "\n" + "="*60
puts "SEED MODE: #{seed_mode.upcase}"
puts "="*60 + "\n"

# ============================================
# LIMPIEZA CONDICIONAL
# ============================================
unless seed_mode == 'append'
  puts "\n🗑️  Cleaning database..."
  puts "   Deleting Runners..."
  Runner.delete_all
  puts "   Deleting Messages..."
  Message.delete_all
  puts "   Deleting Conversation Participants..."
  ConversationParticipant.delete_all
  puts "   Deleting Conversations..."
  Conversation.delete_all
  puts "   Deleting Races..."
  Race.delete_all
  puts "   Deleting Intros..."
  Intro.delete_all
  puts "   Deleting Users..."
  User.delete_all
  puts "   ✅ Database cleaned\n\n"
else
  puts "\n➕ APPEND MODE: Manteniendo datos existentes\n\n"
end

# ============================================
# CREAR USUARIOS
# ============================================
puts "👤 Creating users..."
users = []

# Martin (solo si no existe)
martin = User.find_by(email: 'm@m.m')
if martin
  puts "   ⏭️  Martin already exists, skipping"
  users << martin
else
  users << User.create!(
  name: 'Martin',
  email: 'm@m.m',
  password: '123456'
  )
  puts "   ✅ Created: Martin (m@m.m)"
end

# Usuarios adicionales
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
  email = "#{first_name}@runner.com"
  
  # Verificar si ya existe (importante en modo append)
  existing_user = User.find_by(email: email)
  
  if existing_user
  puts "   ⏭️  #{name} already exists, skipping"
  users << existing_user
  else
  user = User.create!(
    name: name,
    email: email,
    password: '123456'
  )
  users << user
  puts "   ✅ Created: #{name} (#{email})"
  end
end

puts "   ✅ #{users.count} users total\n\n"

# ============================================
# FOTOS
# ============================================
if Rails.env.production?
  puts "📸 Skipping photos in production (users can upload manually)"
  puts "   ℹ️  Photos will be available after manual upload\n\n"
else
  puts "📸 Processing profile photos..."
  
  male_names = ['Carlos', 'David', 'Pablo', 'Jorge']
  female_names = ['Laura', 'Ana', 'María', 'Sara']

  users[1..-1].each_with_index do |user, index|
    # Verificar foto existente
    if user.photo.attached?
      begin
        user.photo.blob.download
        puts "   ✓ #{user.name}: Already has valid photo"
        next
      rescue ActiveStorage::IntegrityError
        puts "   ⚠️  #{user.name}: Corrupted photo, replacing..."
        user.photo.purge
      rescue => e
        puts "   ⚠️  #{user.name}: Error checking photo, replacing..."
        user.photo.purge
      end
    end
    
    # Adjuntar nueva foto
    max_retries = 3
    retry_count = 0
    success = false
    
    while retry_count < max_retries && !success
      begin
        first_name = user.name.split.first
        gender = if male_names.include?(first_name)
                   'men'
                 elsif female_names.include?(first_name)
                   'women'
                 else
                   index.even? ? 'men' : 'women'
                 end
        
        photo_id = (index % 99) + 1
        uri = URI("https://randomuser.me/api/portraits/#{gender}/#{photo_id}.jpg")
        
        file = URI.open(uri, read_timeout: 15, open_timeout: 15)
        
        user.photo.attach(
          io: file,
          filename: "avatar_#{user.id}.jpg",
          content_type: 'image/jpeg'
        )
        
        if user.photo.attached?
          user.photo.blob.download
          puts "   ✓ #{user.name}: Photo attached (attempt #{retry_count + 1})"
          success = true
        else
          raise "Photo not attached"
        end
        
      rescue => e
        retry_count += 1
        if retry_count < max_retries
          puts "   ⚠️  #{user.name}: Error (attempt #{retry_count}/#{max_retries}), retrying..."
          sleep(2 * retry_count)
        else
          puts "   ✗ #{user.name}: Failed after #{max_retries} attempts"
        end
      end
    end
  end

  puts "   ✅ Photos processed\n\n"
end

# ============================================
# INTROS
# ============================================
puts "📝 Creating intros..."

users.each do |user|
  # Verificar si ya tiene intro (modo append)
  if user.intro
  puts "   ⏭️  #{user.name}: Already has intro"
  else
  intro_text = Faker::Lorem.paragraph(sentence_count: 2)[0..219]
  Intro.create!(
    user: user,
    about: intro_text
  )
  puts "   ✓ #{user.name}: Intro created"
  end
end

puts "   ✅ Intros processed\n\n"

# ============================================
# RACES
# ============================================
if seed_mode != 'append' || Race.count == 0
  puts "🏃 Creating races..."
  puts "   (This may take a moment due to geocoding...)\n"
  
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
  "Montjuïc, Barcelona, España"
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

  races_created = 0
  races_failed = 0
  
  race_names.each_with_index do |race_name, index|
  begin
    year = [2026, 2027].sample
    month = (1..12).to_a.sample
    day = (1..28).to_a.sample
    hour = [8, 9, 10, 17, 18, 19, 20].sample
    minute = [0, 15, 30, 45].sample

    race = Race.create!(
    name: race_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    length: [3, 5, 7, 10, 15, 21].sample,
    meet_point: addresses.sample,
    start_date: DateTime.new(year, month, day, hour, minute),
    public: index < 12,
    user: users.sample
    )

    Runner.create!(user: race.user, race: race)
    
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
    visibility = race.public? ? "🌍" : "🔒"
    geocoded = race.geocoded? ? "📍" : "❌"
    
    puts "   #{visibility} #{geocoded} #{race.name} - #{race.length}km - #{race.runners.count} runners"

  rescue ActiveRecord::RecordInvalid => e
    puts "   ✗ #{race_name}: VALIDATION ERROR"
    e.record.errors.full_messages.each { |msg| puts "      - #{msg}" }
    races_failed += 1
  rescue => e
    puts "   ✗ #{race_name}: #{e.class} - #{e.message}"
    races_failed += 1
  end
  end

  puts "\n   📊 Race creation summary:"
  puts "      ✓ Created: #{races_created}"
  puts "      ✗ Failed:  #{races_failed}"
  puts "      📝 Expected: #{race_names.length}"
  
  if races_failed > 0
  puts "\n   ⚠️  Some races failed (see errors above)"
  end
  
  puts "   ✅ Races processed\n\n"
else
  puts "🏃 Skipping races (APPEND mode with existing races)\n\n"
end

# ============================================
# RESUMEN
# ============================================
puts "="*60
puts "📊 SEED SUMMARY"
puts "="*60
puts "Mode:               #{seed_mode.upcase}"
puts "Users:              #{User.count}"
puts "Users with photos:  #{User.joins(:photo_attachment).count}"
puts "Intros:             #{Intro.count}"
puts "Races:              #{Race.count}"
puts "Runners:            #{Runner.count}"
puts "="*60
puts "\n✅ Seeds completed successfully!\n\n"