FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { Faker::Internet.user_name }
    factory :novice do
      user_type :novice
      status :not_qualified
    end
    factory :expert do
      user_type :expert
      status :qualified
      profession { Faker::Company.profession }
      service { Faker::Company.industry }
    end
  end
end