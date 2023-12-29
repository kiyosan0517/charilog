FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    my_bike { User.my_bikes.values.sample }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
