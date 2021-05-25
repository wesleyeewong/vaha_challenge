# frozen_string_literal: true

require "rails_helper"

RSpec.describe Internal::Workout::UpdateInteractor do
  let(:trainer) { create(:trainer) }
  let(:state) { "draft" }
  let(:workout) { create(:workout, trainer: trainer) }
  let(:workout_params) do
    {
      exercises: [
        { slug: "pushups", duration: 30 },
        { slug: "situps", duration: 45 }
      ],
      slug: "ramblin",
      state: state
    }
  end
  let(:interactor) { described_class.new(trainer, workout.id, workout_params) }

  before do
    create(:exercise, slug: "pushups")
    create(:exercise, slug: "situps")
  end

  describe "validation:" do
    it "is valid when parameters are valid" do
      expect(interactor).to be_valid
    end

    context "when exercise doesn't exist" do
      let(:workout_params) do
        {
          exercises: [
            { slug: "bench-presses", duration: 30 },
            { slug: "deadlifts", duration: 45 }
          ],
          slug: "ramblin",
          state: "draft"
        }
      end

      it "is invalid" do
        error_message = {
          exercise_slugs: ["[\"bench-presses\", \"deadlifts\"] exercises are invalid"]
        }

        expect(interactor).not_to be_valid
        expect(interactor.errors.messages).to eq(error_message)
      end
    end

    context "when duration is not integer" do
      let(:workout_params) do
        {
          exercises: [
            { slug: "pushups", duration: "30" },
            { slug: "situps", duration: "hello" }
          ],
          slug: "ramblin",
          state: "draft"
        }
      end

      it "is invalid" do
        error_message = {
          durations: ["Durations: [\"30\", \"hello\"] aren't valid"]
        }

        expect(interactor).not_to be_valid
        expect(interactor.errors.messages).to eq(error_message)
      end
    end

    context "when state is not supported" do
      let(:state) { "wreck" }

      it "is invalid" do
        error_message = {
          workout_state: ["wreck is not a valid state"]
        }

        expect(interactor).not_to be_valid
        expect(interactor.errors.messages).to eq(error_message)
      end
    end

    context "when state is not passed in" do
      let(:workout_params) do
        {
          exercises: [
            { slug: "pushups", duration: 30 },
            { slug: "situps", duration: 45 }
          ],
          slug: "ramblin"
        }
      end

      it "is valid" do
        expect(interactor).to be_valid
      end
    end

    context "when workout slug is not passed in" do
      let(:workout_params) do
        {
          exercises: [
            { slug: "pushups", duration: 30 },
            { slug: "situps", duration: 45 }
          ],
          state: "published"
        }
      end

      it "is not valid" do
        error_message = {
          workout_slug: ["can't be blank"]
        }

        expect(interactor).not_to be_valid
        expect(interactor.errors.messages).to eq(error_message)
      end
    end

    context "when trainer already has workout with the same slug" do
      it "is invalid" do
        create(:workout, trainer: trainer, slug: "ramblin")

        error_message = {
          workout_slug: ["has already been taken"]
        }

        expect(interactor).not_to be_valid
        expect(interactor.errors.messages).to eq(error_message)
      end
    end
  end

  describe "#call" do
    it "updates workout with the specified params" do
      workout

      expect(trainer.workouts.first.workout_exercises.count).to eq(1)
      expect do
        expect(interactor.call).to eq(true)
      end.to change(Workout, :count).by(0).and change(WorkoutExercise, :count).by(1)

      trainer.reload

      expect(trainer.workouts.count).to eq(1)
      expect(trainer.workouts.first.workout_exercises.count).to eq(2)
      expect(trainer.workouts.first.exercises.pluck(:slug)).to eq(%w[pushups situps])
      expect(trainer.workouts.first.workout_exercises.pluck(:duration)).to eq([30, 45])
      expect(trainer.workouts.first.slug).to eq("ramblin")
      expect(trainer.workouts.first.state).to eq(state)
    end
  end
end
