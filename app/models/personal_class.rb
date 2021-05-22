# frozen_string_literal: true

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
class PersonalClass < ApplicationRecord
  belongs_to :trainer
  belongs_to :trainee
end
