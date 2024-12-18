# frozen_string_literal: true

# == Schema Information
#
# Table name: workouts
#
#  id         :integer          not null, primary key
#  slug       :string           not null
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trainer_id :integer          not null
#
# Indexes
#
#  index_workouts_on_trainer_id  (trainer_id)
#
# Foreign Keys
#
#  trainer_id  (trainer_id => trainers.id)
#
FactoryBot.define do
  factory :workout do
    sequence(:slug) { |x| "#{trainer.first_name}_workout_#{x}" }
    trainer { create(:trainer) }
    state { "draft" }
    workout_exercises { [association(:workout_exercise, workout: instance)] }

    trait :published do
      state { "published" }
      workout_exercises { [association(:workout_exercise, workout: instance)] }
    end
  end
end
