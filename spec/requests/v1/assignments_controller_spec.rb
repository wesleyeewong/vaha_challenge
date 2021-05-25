# frozen_string_literal: true

require "rails_helper"

RSpec.describe "v1/trainees/:trainee_id/assignments" do
  let(:workout) { create(:workout) }
  let(:trainer) { create(:trainer) }
  let(:trainee) { create(:trainee) }
  let(:assignment) { create(:assignment, trainer: trainer, trainee: trainee, assignable: workout) }

  before do
    create(:personal_class, trainer: trainer, trainee: trainee)
  end

  describe "GET" do
    describe "/" do
      let(:do_get) { json_request_with_token(trainee, :get, path) }
      let(:path) { "/v1/trainees/#{trainee.id}/assignments" }

      it "returns all assignments without assignment details" do
        time = Time.current

        2.times { create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: time) }

        do_get

        expected = [
          {
            "assigned_by" => trainer.full_name,
            "assignment_type" => "Workout",
            "completed" => false,
            "assigned_at" => time.strftime("%d/%m/%Y")
          },
          {
            "assigned_by" => trainer.full_name,
            "assignment_type" => "Workout",
            "completed" => false,
            "assigned_at" => time.strftime("%d/%m/%Y")
          }
        ]

        expect(response).to have_http_status(:ok)
        expect(json_response["assignments"]).to eq(expected)
      end

      context "when trainee has no assignments" do
        it "returns empty json" do
          do_get

          expect(response).to have_http_status(:ok)
          expect(json_response["assignments"]).to eq([])
        end
      end
    end

    describe "/:assignment_id" do
      let(:path) { "/v1/trainees/#{trainee.id}/assignments/#{assignment.id}" }
      let(:do_get) { json_request_with_token(trainee, :get, path) }

      it "returns assignment with assignment details" do
        assignment

        do_get

        expected = {
          "assigned_by" => trainer.full_name,
          "assignment_type" => "Workout",
          "completed" => false,
          "assigned_at" => assignment.created_at.strftime("%d/%m/%Y"),
          "assignment" => {
            "exercises" => [{ "slug" => "squats", "duration" => 60, "order" => 1 }],
            "total_duration" => 60
          }
        }

        expect(response).to have_http_status(:ok)
        expect(json_response["assignment"]).to eq(expected)
      end

      context "when assignment doesn't exist" do
        let(:path) { "/v1/trainees/#{trainee.id}/assignments/-404" }

        it "returns not_found status" do
          do_get

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
