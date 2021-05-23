# frozen_string_literal: true

# == Schema Information
#
# Table name: workout_exercises
#
#  id          :integer          not null, primary key
#  duration    :integer
#  order       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  exercise_id :integer          not null
#  workout_id  :integer          not null
#
# Indexes
#
#  index_workout_exercises_on_exercise_id  (exercise_id)
#  index_workout_exercises_on_workout_id   (workout_id)
#
# Foreign Keys
#
#  exercise_id  (exercise_id => exercises.id)
#  workout_id   (workout_id => workouts.id)
#
FactoryBot.define do
  factory :workout_exercise, class: "WorkoutExercise" do
    workout { create(:workout) }
    exercise { create(:exercise) }
    order { 1 }
    duration { 60 }
  end
end
