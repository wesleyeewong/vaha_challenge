# frozen_string_literal: true

# == Schema Information
#
# Table name: trainees
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

RSpec.describe Trainee, type: :model do
  describe "validations:" do
    it "should have valid factory" do
      expect(build(:trainee)).to be_valid
    end
  end
end
