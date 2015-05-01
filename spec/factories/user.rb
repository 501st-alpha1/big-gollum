FactoryGirl.define do
  factory :user do
    email "user@example.com"
    password "password123"

    trait :admin do
      email "admin-user@example.com"
    end
  end
end