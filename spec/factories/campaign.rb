FactoryBot.define do
  factory :campaign do
    title { Faker::Company.name }
    duration "7 days"
  end
end