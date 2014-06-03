# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create(name: 'Admin')
Role.create(name: 'User')

User.create(name: 'Admin', email: 'admin@smadbook.com', password_digest: '$2a$10$ILqNjYGjgNAJUY952GFHuuPP3ro5.fRD8elcbLM51lELfEyw/JcYO', role: 1)
User.create(name: 'User', email: 'user@smadbook.com', password_digest: '$2a$10$gNMtagnRO.Yeh.iKL/HQZu6r47terGX33IKHoBv6L0gWjYYmm9iBq', role: 2)

News.create(title: 'Dies ist eine Beispiel-News', text: 'Diest ist ein Beispiel-Text', author: 1)
