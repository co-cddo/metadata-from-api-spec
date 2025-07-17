FactoryBot.define do
  factory :record do
    url { Faker::Internet.url }
    metadata { info.merge(identifier: SecureRandom.uuid) }
    specification do
      {
        openapi: "3.0.0",
        info:,
      }
    end
    transient do
      info do
        {
          title: Faker::Commerce.product_name,
          description: Faker::Lorem.paragraph,
        }
      end
    end
    trait :invalid do
      url { "" }
    end
  end
end
