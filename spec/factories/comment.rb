FactoryBot.define do
  factory :comment do
    content { Faker::StarWars.quote }
  end
end