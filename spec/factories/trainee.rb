# frozen_string_literal: true

FactoryBot.define do
  factory :trainee do
    first_name { "Elvis" }
    last_name { "Presley" }
    email { "elvis.presley@groovy.com" }
  end
end
