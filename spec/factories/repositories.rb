FactoryBot.define do
  factory :repository do
    name { Faker::Company.name }
    group { Faker::Company.name }
  end
end
