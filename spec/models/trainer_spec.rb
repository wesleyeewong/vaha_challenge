# frozen_string_literal: true

# == Schema Information
#
# Table name: trainers
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  password_digest :string           not null
#  expertise       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

RSpec.describe Trainer, type: :model do
  describe "validations:" do
    it "shoulld have valid factory" do
      expect(build(:trainer)).to be_valid
    end
  end
end
