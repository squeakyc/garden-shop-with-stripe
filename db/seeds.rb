# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# add the destroy_all line to remove all other categories you added and reset database
# Category.destroy_all!

categories = Category.create([{name: "Annuals" }, {name: "Perennials" },
  {name: "Tools" }, {name: "Chemicals" }, {name: "Wildlife" }])
