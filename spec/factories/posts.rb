FactoryBot.define do
  factory :post do
    word  {Faker::Lorem.sentence(word_count:2)}
    mean  {Faker::Lorem.sentence(word_count:2)}
  end
end
