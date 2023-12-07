# frozen_string_literal: true

FactoryBot.define do
  sequence(:username) { |n| "user#{n}" }
  sequence(:email) { |n| "user#{n}@sagittarius.code0.tech" }
  sequence(:password) { |n| "#{SecureRandom.base58(10)}-#{n}" }

  factory :user do
    username { generate(:username) }
    email { generate(:email) }
    password { generate(:password) }
  end
end
