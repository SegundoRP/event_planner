# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.create!(
  email: 'example1@gmail.com',
  role: 'organizer',
  first_name: 'John 1',
  last_name: 'Doe 1'
)

User.create!(
  email: 'example2@gmail.com',
  role: 'employee',
  first_name: 'John 2',
  last_name: 'Doe 2'
)
