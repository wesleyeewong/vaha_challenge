# frozen_string_literal: true

class User < ApplicationRecord
  self.abstract_class = true

  has_secure_password

  def full_name
    "#{first_name} #{last_name}"
  end
end
