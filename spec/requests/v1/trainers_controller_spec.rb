# frozen_string_literal: true

require "rails_helper"

RSpec.describe "v1/trainers" do
  let(:trainee) { create(:trainee) }

  describe "GET" do
    let(:do_get) { json_request_with_token(trainee, :get, path, params) }
    let(:params) { {} }

    describe "/" do
      let(:path) { "/v1/trainers" }

      context "when there are no trainers" do
        it "returns empty json" do
          do_get

          expect(response).to have_http_status(:ok)
          expect(json_response["trainers"]).to eq([])
        end
      end

      context "when there are trainers" do
        it "returns trainers" do
          2.times { create(:trainer) }

          expected = Array.new(2).map do
            {
              "first_name" => "Nama",
              "last_name" => "Ste",
              "expertise" => "yoga"
            }
          end

          do_get

          expect(response).to have_http_status(:ok)
          expect(json_response["trainers"].size).to eq(2)
          expect(json_response["trainers"]).to match_array(expected)
        end
      end

      context "when filters present" do
        before do
          create(:trainer)
          create(:trainer, expertise: "strength")
          create(:trainer, expertise: "fitness")
        end

        context "with one filter" do
          let(:params) { { expertise: ["yoga"] } }

          it "filters trainers" do
            do_get

            expected = [
              { "first_name" => "Nama", "last_name" => "Ste", "expertise" => "yoga" }
            ]

            expect(response).to have_http_status(:ok)
            expect(json_response["trainers"].size).to eq(1)
            expect(json_response["trainers"]).to match_array(expected)
          end
        end

        context "with multiple filters" do
          let(:params) { { expertise: %w[yoga strength] } }

          it "filters trainers" do
            do_get

            expected = [
              { "first_name" => "Nama", "last_name" => "Ste", "expertise" => "yoga" },
              { "first_name" => "Nama", "last_name" => "Ste", "expertise" => "strength" }
            ]

            expect(response).to have_http_status(:ok)
            expect(json_response["trainers"].size).to eq(2)
            expect(json_response["trainers"]).to match_array(expected)
          end
        end
      end
    end

    describe "/:id" do
      let(:trainer) { create(:trainer) }
      let(:path) { "/v1/trainers/#{trainer.id}" }

      it "returns trainer json" do
        do_get

        expected = { "first_name" => "Nama", "last_name" => "Ste", "expertise" => "yoga" }

        expect(response).to have_http_status(:ok)
        expect(json_response["trainer"]).to eq(expected)
      end

      context "when trainer doesn't exst" do
        let(:path) { "/v1/trainers/-404" }
        it "returns not_found status" do
          do_get

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
