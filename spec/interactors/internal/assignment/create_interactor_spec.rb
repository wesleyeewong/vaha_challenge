# frozen_string_literal: true

require "rails_helper"

RSpec.describe Internal::Assignment::CreateInteractor do
  let(:trainer) { create(:trainer) }
  let(:trainee) { create(:trainee) }
  let(:personal_class) { create(:personal_class, trainer: trainer, trainee: trainee) }
  let(:workout) { create(:workout, :published, trainer: trainer) }
  let(:assignment_params) { { type: "Workout", id: workout.id } }
  let(:interactor) { described_class.new(trainer, trainee, assignment_params) }

  describe "validations:" do
    it "is valid with valid params" do
      expect(interactor).to be_valid
    end

    context "when assignable type invalid" do
      let(:assignment_params) { { type: "Medidation", id: 1 } }

      it "is invalid" do
        error_message = { assignable_type: ["is invalid"] }

        expect(interactor).not_to be_valid
        expect(interactor.errors.messages).to eq(error_message)
      end
    end

    context "when assignable doesn't exist" do
      let(:assignment_params) { { type: "Workout", id: -404 } }

      it "is invalid" do
        error_message = { assignable: ["Workout not found"] }

        expect(interactor).not_to be_valid
        expect(interactor.errors.messages).to eq(error_message)
      end
    end
  end

  describe "#call" do
    it "creates assignment for trainee, assigned by trainer" do
      expect do
        expect(interactor.call).to eq(true)
      end.to change(Assignment, :count).by(1)

      trainee.reload

      expect(trainee.assignments.count).to eq(1)
      expect(trainee.assignments.workouts.count).to eq(1)
      expect(trainee.assignments.first.assignable_id).to eq(workout.id)
      expect(trainee.assignments.first.assignable_type).to eq("Workout")
    end
  end
end
