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

        assignment1 = create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: time)
        assignment2 = create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: time)

        do_get

        expected = [
          {
            "assigned_by" => trainer.full_name,
            "assignment_type" => "Workout",
            "completed" => false,
            "assigned_at" => time.strftime("%d/%m/%Y"),
            "id" => assignment1.id

          },
          {
            "assigned_by" => trainer.full_name,
            "assignment_type" => "Workout",
            "completed" => false,
            "assigned_at" => time.strftime("%d/%m/%Y"),
            "id" => assignment2.id
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

      context "when start date passed in" do
        let(:start_date) { "01-11-2021" }
        let(:path) { "/v1/trainees/#{trainee.id}/assignments?start_date=#{start_date}" }

        it "filters based on date" do
          start = DateTime.parse(start_date)

          # included
          included = create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: start)

          # excluded
          create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: start - 1)

          do_get

          expected = [
            {
              "assigned_by" => trainer.full_name,
              "assignment_type" => "Workout",
              "completed" => false,
              "assigned_at" => start.strftime("%d/%m/%Y"),
              "id" => included.id
            }
          ]

          expect(response).to have_http_status(:ok)
          expect(json_response["assignments"]).to eq(expected)
        end
      end

      context "when end date passed in" do
        let(:end_date) { "01-11-2021" }
        let(:path) { "/v1/trainees/#{trainee.id}/assignments?end_date=#{end_date}" }

        it "filters based on date" do
          parsed_end = DateTime.parse(end_date)

          # included
          included =
            create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: parsed_end)

          # excluded
          create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: parsed_end + 1)

          do_get

          expected = [
            {
              "assigned_by" => trainer.full_name,
              "assignment_type" => "Workout",
              "completed" => false,
              "assigned_at" => parsed_end.strftime("%d/%m/%Y"),
              "id" => included.id
            }
          ]

          expect(response).to have_http_status(:ok)
          expect(json_response["assignments"]).to eq(expected)
        end
      end

      context "when both start and end date passed in" do
        let(:start_date) { "01-11-2021" }
        let(:end_date) { "05-11-2021" }
        let(:path) { "/v1/trainees/#{trainee.id}/assignments?start_date=#{start_date}&end_date=#{end_date}" }

        it "filters based on date" do
          parsed_start = DateTime.parse(start_date)
          parsed_end = DateTime.parse(end_date)

          # included
          included1 = 
            create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: parsed_start)
          included2 =
            create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: parsed_end)

          # excluded
          create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: parsed_start - 1)
          create(:assignment, trainer: trainer, trainee: trainee, assignable: workout, created_at: parsed_end + 1)

          do_get

          expected = [
            {
              "assigned_by" => trainer.full_name,
              "assignment_type" => "Workout",
              "completed" => false,
              "assigned_at" => parsed_start.strftime("%d/%m/%Y"),
              "id" => included1.id
            },
            {
              "assigned_by" => trainer.full_name,
              "assignment_type" => "Workout",
              "completed" => false,
              "assigned_at" => parsed_end.strftime("%d/%m/%Y"),
              "id" => included2.id
            }
          ]

          expect(response).to have_http_status(:ok)
          expect(json_response["assignments"]).to match_array(expected)
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
          "id" => assignment.id,
          "assignment" => {
            "exercises" => [{ "slug" => "squats", "duration" => 60, "order" => 1 }],
            "total_duration" => 60,
            "id" => workout.id
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
