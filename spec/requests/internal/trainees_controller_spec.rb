# frozen_string_literal: true

require "rails_helper"

RSpec.describe "internal/trainers/:trainer_id/trainees" do
  let(:trainer) { create(:trainer) }

  describe "GET" do
    let(:do_get) { json_request_with_token(trainer, :get, path) }

    describe "/" do
      let(:path) { "/internal/trainers/#{trainer.id}/trainees" }

      context "when there are no trainees" do
        it "returns empty json" do
          do_get

          expect(response).to have_http_status(:ok)
          expect(json_response["trainees"]).to eq([])
        end
      end

      context "when there are trainees enrolled to trainer" do
        it "returns trainees" do
          class1 =  create(:personal_class, trainer: trainer)
          class2 =  create(:personal_class, trainer: trainer)

          expected = [
            {
              "first_name" => class1.trainee.first_name,
              "last_name" => class1.trainee.last_name,
              "email" => class1.trainee.email,
              "id" => class1.trainee.id
            },
            {
              "first_name" => class2.trainee.first_name,
              "last_name" => class2.trainee.last_name,
              "email" => class2.trainee.email,
              "id" => class2.trainee.id
            }
          ]

          do_get

          expect(response).to have_http_status(:ok)
          expect(json_response["trainees"].size).to eq(2)
          expect(json_response["trainees"]).to match_array(expected)
        end
      end
    end

    describe "/:trainee_id" do
      let(:trainer) { create(:trainer) }
      let(:trainee) { create(:personal_class, trainer: trainer).trainee }
      let(:path) { "/internal/trainers/#{trainer.id}/trainees/#{trainee.id}" }

      it "returns trainee json" do
        do_get

        expected = { "first_name" => "Elvis", "last_name" => "Presley", "email" => trainee.email, "id" => trainee.id }

        expect(response).to have_http_status(:ok)
        expect(json_response["trainee"]).to eq(expected)
      end

      context "when trainee not enrolled to trainer" do
        let(:trainee) { create(:trainee) }
        let(:path) { "/internal/trainers/#{trainer.id}/trainees/#{trainee.id}" }

        it "returns not_found status" do
          do_get

          expect(response).to have_http_status(:not_found)
        end
      end

      context "when trainee doesn't exist" do
        let(:path) { "/internal/trainers/#{trainer.id}/trainees/-404" }

        it "returns not_found status" do
          do_get

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
