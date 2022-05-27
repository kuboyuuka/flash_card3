FactoryBot.define do
  factory :post do
    word             {Faker::Lorem.sentence}
    mean             {Faker::Lorem.sentence}
  end
end
