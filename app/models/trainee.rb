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
class Trainee < User
end
