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
FactoryBot.define do
  factory :personal_class do
    trainer { create(:trainer) }
    trainee { create(:trainee) }
    started_at { Time.current }
  end
end
