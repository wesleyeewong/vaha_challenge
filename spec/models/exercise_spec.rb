# frozen_string_literal: true

# == Schema Information
#
# Table name: exercises
#
#  id         :integer          not null, primary key
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Exercise, type: :model do
  describe "validations:" do
    it "has valid factory" do
      expect(build(:exercise)).to be_valid
    end
  end
end
