# frozen_string_literal: true

FactoryBot.define do
  factory :employee, class: 'Employee::Base' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    phone_number { "+523121118900" }
  end
end
