FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "test-title-#{n}" }
    sequence(:content) { |n| "test-content-#{n}" }
    association :user
  end
end
