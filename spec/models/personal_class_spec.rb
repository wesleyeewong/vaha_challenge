# frozen_string_literal: true

# == Schema Information
#
# Table name: personal_classes
#
#  id         :integer          not null, primary key
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trainee_id :integer          not null
#  trainer_id :integer          not null
#
# Indexes
#
#  index_personal_classes_on_trainee_id  (trainee_id)
#  index_personal_classes_on_trainer_id  (trainer_id)
#
# Foreign Keys
#
#  trainee_id  (trainee_id => trainees.id)
#  trainer_id  (trainer_id => trainers.id)
#
require "rails_helper"

RSpec.describe PersonalClass, type: :model do
  describe "validations:" do
    it "should have valid factory" do
      expect(build(:personal_class)).to be_valid
    end
  end
end
