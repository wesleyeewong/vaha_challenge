# frozen_string_literal: true

require "rails_helper"

RSpec.describe "internal/trainers/:trainer_id/workouts" do
  let(:trainer) { create(:trainer) }

  describe "POST /" do
    let(:path) { "/internal/trainers/#{trainer.id}/workouts" }
    let(:do_post) { json_request_with_token(trainer, :post, path, params) }
    let(:params) do
      {
        workout: {
          exercises: [
            { slug: "pushups", duration: 30 },
            { slug: "pushups", duration: 40 }
          ],
          slug: "my_workout",
          state: "draft"
        }
      }
    end

    it "creates workout and return workout json" do
      create(:exercise, slug: "pushups")

      expected = {
        "exercises" => [
          { "slug" => "pushups", "duration" => 30, "order" => 1 },
          { "slug" => "pushups", "duration" => 40, "order" => 2 }
        ],
        "state" => "draft",
        "total_duration" => 70
      }

      expect(trainer.workouts.count).to eq(0)

      expect do
        do_post
      end.to change(Workout, :count).by(1).and change(WorkoutExercise, :count).by(2)

      expect(response).to have_http_status(:created)
      expect(json_response["workout"]).to eq(expected)
      expect(trainer.workouts.count).to eq(1)
    end

    context "when params are not valid" do
      let(:params) do
        {
          workout: {
            exercises: [{ slug: "pushups", duration: 30 }],
            slug: "my_workout",
            state: "draft"
          }
        }
      end

      it "returns unprocessable_entity status" do
        do_post

        expected_error = { "exercise_slugs" => ["[\"pushups\"] exercises are invalid"] }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to eq(expected_error)
      end
    end
  end

  describe "DELETE /:workout_id" do
    let(:trainer) { create(:trainer, :with_published_workout) }
    let(:workout) { trainer.workouts.first }
    let(:path) { "/internal/trainers/#{trainer.id}/workouts/#{workout.id}" }
    let(:do_delete) { json_request_with_token(trainer, :delete, path) }

    it "deletes workout" do
      workout

      expect(trainer.workouts.count).to eq(1)
      expect do
        do_delete
      end.to change(Workout, :count).by(-1)
      expect(response).to have_http_status(:no_content)
      expect(trainer.reload.workouts.count).to eq(0)
    end

    context "when workout doesn't belong to trainer" do
      let(:workout) { create(:workout) }

      it "returns not_found status" do
        do_delete

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when workout doesn't exist" do
      let(:path) { "/internal/trainers/#{trainer.id}/workouts/-404" }

      it "returns not_found status" do
        do_delete

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET" do
    let(:do_get) { json_request_with_token(trainer, :get, path) }

    describe "/" do
      let(:path) { "/internal/trainers/#{trainer.id}/workouts" }

      context "when there are no workouts" do
        it "returns empty json" do
          do_get

          expect(response).to have_http_status(:ok)
          expect(json_response["workouts"]).to eq([])
        end
      end

      context "when there are published workouts created by trainer" do
        let(:trainer) { create(:trainer, :with_published_workout) }

        it "returns json with workout" do
          do_get

          expected = [
            {
              "exercises" => [{ "slug" => "squats", "order" => 1, "duration" => 60 }],
              "total_duration" => 60,
              "state" => "published"
            }
          ]

          expect(response).to have_http_status(:ok)
          expect(json_response["workouts"]).to eq(expected)
        end
      end

      context "when there are draft workouts created by trainer" do
        let(:trainer) { create(:trainer, :with_draft_workout) }

        it "returns json with workout" do
          do_get

          expected = [
            {
              "exercises" => [{ "slug" => "squats", "order" => 1, "duration" => 60 }],
              "total_duration" => 60,
              "state" => "draft"
            }
          ]

          expect(response).to have_http_status(:ok)
          expect(json_response["workouts"]).to eq(expected)
        end
      end

      context "when there are both published and draf workouots created by trainer" do
        let(:trainer) { create(:trainer, :with_published_and_draft_workout) }

        it "returns json with workout" do
          do_get

          expected = [
            {
              "exercises" => [{ "slug" => "squats", "order" => 1, "duration" => 60 }],
              "total_duration" => 60,
              "state" => "draft"
            },
            {
              "exercises" => [{ "slug" => "squats", "order" => 1, "duration" => 60 }],
              "total_duration" => 60,
              "state" => "published"
            }
          ]

          expect(response).to have_http_status(:ok)
          expect(json_response["workouts"]).to eq(expected)
        end
      end
    end

    describe "/:workout_id" do
      let(:trainer) { create(:trainer, :with_published_workout) }
      let(:workout) { trainer.workouts.first }
      let(:path) { "/internal/trainers/#{trainer.id}/workouts/#{workout.id}" }

      it "returns json with workout" do
        do_get

        expected = {
          "exercises" => [{ "slug" => "squats", "order" => 1, "duration" => 60 }],
          "total_duration" => 60,
          "state" => "published"
        }

        expect(response).to have_http_status(:ok)
        expect(json_response["workout"]).to eq(expected)
      end

      context "when workout doesn't belong to trainer" do
        let(:workout) { create(:workout) }

        it "returns not_found status" do
          do_get

          expect(response).to have_http_status(:not_found)
        end
      end

      context "when workout doesn't exist" do
        let(:path) { "/internal/trainers/#{trainer.id}/workouts/-404" }

        it "returns not_found status" do
          do_get

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "PUT /:workout_id" do
    let(:trainer) { create(:trainer, :with_published_workout) }
    let(:workout) { trainer.workouts.first }
    let(:path) { "/internal/trainers/#{trainer.id}/workouts/#{workout.id}" }
    let(:do_put) { json_request_with_token(trainer, :put, path, params) }
    let(:params) do
      {
        workout: {
          exercises: [
            { slug: "pushups", duration: 30 },
            { slug: "pushups", duration: 40 }
          ],
          slug: "my_workout",
          state: "draft"
        }
      }
    end

    it "updates workout and return workout json" do
      create(:exercise, slug: "pushups")

      expected = {
        "exercises" => [
          { "slug" => "pushups", "duration" => 30, "order" => 1 },
          { "slug" => "pushups", "duration" => 40, "order" => 2 }
        ],
        "state" => "draft",
        "total_duration" => 70
      }

      expect(trainer.workouts.count).to eq(1)

      expect do
        do_put
      end.to change(Workout, :count).by(0).and change(WorkoutExercise, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(json_response["workout"]).to eq(expected)
      expect(trainer.workouts.count).to eq(1)
    end
  end
end
