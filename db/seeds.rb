# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# shaq = User.find(1)
# shaq.rounds.create(level: 2, score: 500)



town = Movie.create!(title: "The Town", tmdb_id: 3445)
good = Movie.create!(title: "Good Will Hunting", tmdb_id: 3446)

matt = Person.create!(name: "Matt Damon")

matt.cast_members.create!(movie: town)
