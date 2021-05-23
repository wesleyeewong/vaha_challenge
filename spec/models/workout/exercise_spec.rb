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
require "rails_helper"

RSpec.describe Workout::Exercise, type: :model do
  describe "validations:" do
    it "has valid factory" do
      expect(build(:workout_exercise)).to be_valid
    end
  end
end
