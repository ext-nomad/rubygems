# frozen_string_literal: true

User.create!(email: 'admin@exmple.com', password: 'admin@exmple.com', password_confirmation: 'admin@exmple.com')

30.times do
  Course.create!([{
                   title: Faker::Educator.course_name,
                   description: Faker::TvShows::GameOfThrones.quote,
                   user_id: User.first.id
                 }])
end
