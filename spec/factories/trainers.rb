# frozen_string_literal: true

# == Schema Information
#
# Table name: trainers
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  password_digest :string           not null
#  expertise       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :trainer do
    first_name { "Nama" }
    last_name { "Ste" }
    sequence(:email) { |n| "nama.ste#{n}@yoga.com" }
    password { "secret" }
    expertise { "yoga" }
  end

  trait :with_published_workout do
    workouts { [association(:workout, :published, trainer: instance)] }
  end

  trait :with_draft_workout do
    workouts { [association(:workout, trainer: instance)] }
  end

  trait :with_published_and_draft_workout do
    workouts { [association(:workout, trainer: instance), association(:workout, :published, trainer: instance)] }
  end
end
