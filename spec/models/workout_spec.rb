# frozen_string_literal: true

# == Schema Information
#
# Table name: workouts
#
#  id         :integer          not null, primary key
#  slug       :string           not null
#  trainer_id :integer          not null
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Workout, type: :model do
  describe "validations:" do
    it "has valid factory" do
      expect(build(:workout)).to be_valid
    end
  end
end
