# frozen_string_literal: true

class V1::TrainerPresenter < Presenter
  def to_h
    {
      first_name: first_name,
      last_name: last_name,
      expertise: expertise
    }
  end
end
