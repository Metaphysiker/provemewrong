# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env == 'development'

  User.create!(email: "s.raess@me.com", password: "password")

  argu1 = Argumentation.create!(title: "Why we should read classics in the school", description: "This argumentation has three arguments: 1. Classics are full of wisdoms, 2. deliver life-experiences, 3. belong to our culture")
  a1 = Argument.create!(title: "Classics are full of wisdeom and therefore worth reading", description: "Some things can't be learnt by studying facts about nature.")
  a2 = Argument.create!(title: "Some experiences cant be made with living", description: "Luckily, not everyone experiences war, but even then, experiences may difer in the situation.")
  a3 = Argument.create!(title: "Culture is intellectually important", description: "Our culture is more than just kowing some habits and virtues, but also about knowing history.")
  argu1.arguments << a1
  argu1.arguments << a2
  argu1.arguments << a3

  argu2 = Argumentation.create!(title: "Someone is rational, if the person is responsive for good reasons", description: "This argumentation has two arguments: 1. Everyone makes mistakes, but if one repeats them, he is acting irrationally. 2. Good reasons are necessary")
  a2 = Argument.create!(title: "Making mistakes is nothing special, but repeating them, knowingly is irrationally", description: "Rationality is concerned with normativity")
  argu2.arguments << a2

  a1.argumentation = argu2


end