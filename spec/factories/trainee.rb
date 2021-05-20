# frozen_string_literal: true

FactoryBot.define do
  factory :trainee do
    first_name { "Elvis" }
    last_name { "Presley" }
    sequence(:email) { |n| "elvis.presley+#{n}@groovy.com" }
    password { "secret" }
  end
end
