# == Schema Information
#
# Table name: personal_classes
#
#  id         :integer          not null, primary key
#  trainer_id :integer          not null
#  trainee_id :integer          not null
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe PersonalClass, type: :model do
  describe "validations:" do
    it "should have valid factory" do
      expect(build(:personal_class)).to be_valid
    end
  end
end
