# frozen_string_literal: true

require "rails_helper"

RSpec.describe "internal/trainers/:trainer_id/trainees/:trainee_id/assignments" do
  let(:trainer) { create(:trainer) }
  let(:trainee) { create(:trainee) }
  let(:workout) { create(:workout, :published, trainer: trainer) }

  describe "POST /" do
    let(:path) { "/internal/trainers/#{trainer.id}/trainees/#{trainee.id}/assignments" }
    let(:do_post) { json_request_with_token(trainer, :post, path, params) }
    let(:assignment_type) { "Workout" }
    let(:assignment_id) { workout.id }
    let(:params) { { assignment: { type: assignment_type, id: assignment_id } } }

    before do
      create(:personal_class, trainer: trainer, trainee: trainee)
    end

    it "creates and return assignment json" do
      expected = {
        "assigned_by" => trainer.full_name,
        "assignment_type" => assignment_type,
        "assignment" => {
          "exercises" => [{ "slug" => "squats", "duration" => 60, "order" => 1 }],
          "state" => "published",
          "total_duration" => 60
        }
      }

      expect(trainee.assignments.count).to eq(0)

      expect do
        do_post
      end.to change(Assignment, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_response).to eq(expected)
      expect(trainee.assignments.count).to eq(1)
    end

    context "when params are not valid" do
      let(:assignment_type) { "Meditation" }

      it "error message and unprocessabel entity status" do
        do_post

        expected_error = { "assignable_type" => ["is invalid"] }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to eq(expected_error)
      end
    end
  end
end
