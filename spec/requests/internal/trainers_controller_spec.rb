# frozen_string_literal: true

require "rails_helper"

RSpec.describe "internal/trainers" do
  let(:trainer) { create(:trainer) }

  describe "POST /login" do
    let(:path) { "/internal/trainers/login" }
    let(:params) { { email: email, password: password } }
    let(:email) { trainer.email }
    let(:password) { "secret" }
    let(:do_post) { post(path, params: params) }

    it "returns trainer object and token" do
      do_post

      expect(response).to have_http_status(:ok)
      expect(json_response["trainer"]["first_name"]).to eq(trainer.first_name)
      expect(json_response["trainer"]["last_name"]).to eq(trainer.last_name)
      expect(json_response["trainer"]["email"]).to eq(trainer.email)
      expect(json_response["token"]).not_to be_nil
    end

    context "when no matching email" do
      let(:email) { "johndoe@missing.com" }

      it "returns unauthorized" do
        do_post

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when incorrect password" do
      let(:password) { "wrong" }

      it "returns unauthorized" do
        do_post

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
