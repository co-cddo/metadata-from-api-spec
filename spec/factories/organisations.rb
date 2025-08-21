FactoryBot.define do
  factory :organisation do
    name { Faker::Lorem.word }
    group { Faker::Company.name }
  end
end
