# frozen_string_literal: true

# ! NEEDS TO REWORK !

User.create!(email: 'admin@x.com', password: 'admin@x.com', password_confirmation: 'admin@x.com', confirmed_at: DateTime.now)

10.times do |n|
  # name = Faker::Name.name name: name,
  email = "example-#{n + 1}@example.org"
  password = 'password'
  User.create!(email: email, password: password, password_confirmation: password, confirmed_at: DateTime.now)
end

40.times do
  Course.create!([{
                   title: Faker::Educator.subject,
                   description: Faker::Movies::Hobbit.quote,
                   user_id: User.first.id,
                   short_description: Faker::Quote.famous_last_words,
                   language: 'English',
                   level: 'Beginner',
                   price: Faker::Number.between(from: 1000, to: 20_000)
                 }])
end
