# frozen_string_literal: true

require "rails_helper"

RSpec.describe "v1/trainees" do
  let(:trainee) { create(:trainee) }

  describe "POST /login" do
    let(:path) { "/v1/trainees/login" }
    let(:params) { { email: trainee.email } }
    let(:do_post) { post(path, params: params) }

    it "returns trainee object and token" do
      do_post

      expect(response).to have_http_status(:ok)
      expect(json_response["trainee"]["first_name"]).to eq(trainee.first_name)
      expect(json_response["trainee"]["last_name"]).to eq(trainee.last_name)
      expect(json_response["trainee"]["email"]).to eq(trainee.email)
      expect(json_response["token"]).not_to be_nil
    end

    context "when no matching email" do
      let(:params) { { email: "johndoe@missing.com" } }
      it "returns unauthorized" do
        do_post

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
