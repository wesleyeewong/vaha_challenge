# frozen_string_literal: true

require "rails_helper"

RSpec.describe "v1/trainers/:id/personal_classes" do
  let(:trainee) { create(:trainee) }
  let(:trainer) { create(:trainer) }

  describe "POST /" do
    let(:path) { "/v1/trainers/#{trainer.id}/personal_classes" }
    let(:do_post) { json_request_with_token(trainee, :post, path) }
    let(:time) { Time.current }
    let(:expected) do
      {
        "personal_class" => {
          "trainer" => {
            "first_name" => trainer.first_name,
            "last_name" => trainer.last_name,
            "expertise" => trainer.expertise,
            "id" => trainer.id
          },
          "trainee" => {
            "first_name" => trainee.first_name,
            "last_name" => trainee.last_name,
            "email" => trainee.email,
            "id" => trainee.id
          },
          "started_at" => time.strftime("%d/%m/%Y"),
          "id" => PersonalClass.first.id
        }
      }
    end

    before do
      travel_to(time)
    end

    it "creates personal class for trainer, and trainee" do
      do_post

      expect(response).to have_http_status(:created)
      expect(json_response).to eq(expected)
    end

    context "when trainee already enrolled in a class" do
      it "deletes enrolled personal class before enrolling to current class" do
        create(:personal_class, trainee: trainee)

        expect(trainee.personal_class).not_to be_nil
        expect(trainee.personal_trainer).not_to eq(trainer)

        do_post

        expect(response).to have_http_status(:created)
        expect(json_response).to eq(expected)
      end
    end
  end

  describe "DELETE /:personal_class_id" do
    let(:personal_class) { create(:personal_class, trainer: trainer, trainee: trainee) }
    let(:path) { "/v1/trainers/#{trainer.id}/personal_classes/#{personal_class.id}" }
    let(:do_delete) { json_request_with_token(trainee, :delete, path) }

    it "deletes enrolled personal class" do
      personal_class

      expect(trainee.personal_class?).to eq(true)

      expect do
        do_delete
      end.to change(PersonalClass, :count).by(-1)

      expect(response).to have_http_status(:no_content)
      expect(trainee.reload.personal_class?).to eq(false)
    end
  end
end
