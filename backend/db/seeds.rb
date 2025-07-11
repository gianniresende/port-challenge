puts 'Seeding...'

User.find_or_create_by!(email: 'admin@teamtalk.com') do |user|
  user.name = 'Administrador'
  user.password = 'password123'
  user.role = :admin
end

partner_user = User.find_or_create_by!(email: 'parceiro-rh@sistema.com') do |user|
  user.name = 'Sistema de RH'
  user.password = 'password123'
  user.role = :hr
end

unless ApiToken.exists?(user_id: partner_user.id)
  token = ApiToken.create!(user: partner_user)
  puts "Token de API gerado para parceiro: #{token.token}"
else
  token = ApiToken.find_by(user_id: partner_user.id)
  puts "Token já existente para parceiro: #{token.token}"
end
