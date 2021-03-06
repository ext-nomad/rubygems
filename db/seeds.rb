# frozen_string_literal: true

# ! NEEDS TO REWORK !

PublicActivity.enabled = false

User.create!(email: 'admin@x.com', password: 'admin@x.com', password_confirmation: 'admin@x.com', confirmed_at: DateTime.now)

# user = User.new(
#   email: 'admin@x.com',
#   password: 'admin@x.com',
#   password_confirmation: 'admin@x.com'
# )
# user.skip_confirmation!
# user.save!

10.times do |n|
  # name = Faker::Name.name name: name,
  email = "example-#{n + 1}@example.com"
  # password = 'password'
  User.create!(email: email, password: email, password_confirmation: email, confirmed_at: DateTime.now)
end

60.times do
  rand_id = Faker::Number.between(from: 2, to: 6)
  Course.create!([{
                   title: Faker::Educator.subject,
                   description: Faker::Movies::Hobbit.quote,
                   user_id: User.find(rand_id).id,
                   short_description: Faker::Quote.famous_last_words,
                   language: 'English',
                   level: 'Beginner',
                   price: Faker::Number.between(from: 0, to: 1_000)
                 }])
end
PublicActivity.enabled = true
