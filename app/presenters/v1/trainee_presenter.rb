# frozen_string_literal: true

class V1::TraineePresenter < Presenter
  def to_h
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      id: id
    }
  end
end
