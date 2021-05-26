# frozen_string_literal: true

require "rails_helper"

RSpec.describe Internal::WorkoutPresenter do
  describe "#to_h" do
    it "returns has of workout, with total duration and correctly ordered" do
      pushups = create(:exercise, slug: "pushups")
      situps = create(:exercise, slug: "situps")
      workout = create(:workout, slug: "burdell", workout_exercises: [])

      create(:workout_exercise, workout: workout, exercise: pushups, order: 2, duration: 15)
      create(:workout_exercise, workout: workout, exercise: situps, order: 1, duration: 25)

      expected = {
        exercises: [
          { slug: "situps", order: 1, duration: 25 },
          { slug: "pushups", order: 2, duration: 15 }
        ],
        total_duration: 40,
        state: "draft",
        id: workout.id
      }

      expect(described_class.new(workout.reload).to_h).to eq(expected)
    end
  end
end
