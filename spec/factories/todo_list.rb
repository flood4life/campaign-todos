FactoryBot.define do
  factory :todo_list do
    name { Faker::BreakingBad.episode }
  end
end