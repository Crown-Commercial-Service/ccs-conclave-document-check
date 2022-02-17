FactoryBot.define do
  factory :client do
    sequence(:source_app) { |n| "my_app#{n}" }
    api_key { 'RbZHfHtD1h9XZvs4fGPJUgtt' }
  end
end
