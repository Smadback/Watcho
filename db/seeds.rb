# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: 'Admin', email: 'admin@smadbook.com', password: '$2a$10$ILqNjYGjgNAJUY952GFHuuPP3ro5.fRD8elcbLM51lELfEyw/JcYO', password_digest: '$2a$10$ILqNjYGjgNAJUY952GFHuuPP3ro5.fRD8elcbLM51lELfEyw/JcYO', role: 'admin')
User.create(name: 'User', email: 'user@smadbook.com', password_digest: '$2a$10$gNMtagnRO.Yeh.iKL/HQZu6r47terGX33IKHoBv6L0gWjYYmm9iBq', role: 'user')

News.create(title: 'Dies ist eine Beispiel-News', text: 'Diest ist ein Beispiel-Text', user_id: 1)

Show.create(title: "Game of Thrones", airday: "Monday", airtime: "20:00", timezone: "CEST")
Season.create(show_id: 1, number: 1)
Episode.create(season_id: 1, number: 1, starts_at: "2014-06-17")
UserShow.create(user_id: 1, show_id: 1)
