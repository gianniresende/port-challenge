admin_email = 'admin@teamtalk.com'
admin_password = 'password123'

admin = User.find_or_initialize_by(email: admin_email)

if admin.new_record?
  admin.name = 'Admin Padrão'
  admin.password = admin_password
  admin.password_confirmation = admin_password
  admin.role = 'admin'
  admin.status = 'active'

  begin
    admin.save!
    puts "Usuário admin criado: #{admin_email} / #{admin_password}"
  rescue ActiveRecord::RecordInvalid => e
    puts "Erro ao criar usuário admin: #{e.record.errors.full_messages.join(', ')}"
  end

else
  puts "Usuário admin já existe: #{admin_email}"
end