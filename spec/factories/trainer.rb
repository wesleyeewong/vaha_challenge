# frozen_string_literal: true

FactoryBot.define do
  factory :trainer do
    first_name { "Nama" }
    last_name { "Ste" }
    sequence(:email) { |n| "nama.ste#{n}@yoga.com" }
    password { "secret" }
    expertise { "yoga" }
  end
end
