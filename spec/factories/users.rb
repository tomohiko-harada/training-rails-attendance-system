FactoryBot.define do
  factory :user do
    sequence(:mail) { |n| "testuser#{n}@jmty.jp" }
    password { 'password' }
  end
end