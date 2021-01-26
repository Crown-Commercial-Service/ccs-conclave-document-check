FactoryBot.define do
  factory :document do
    source_app { 'myapp' }
    state { 'processing' }
  end
end
