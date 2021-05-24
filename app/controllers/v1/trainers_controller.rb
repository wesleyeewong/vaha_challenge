# frozen_string_literal: true

class V1::TrainersController < ApplicationController
  def index
    @trainers = if expertise_filter.present?
                  Trainer.where(expertise: expertise_filter[:expertise])
                else
                  Trainer.all
                end

    trainers = V1::TrainerPresenter.wrap(@trainers)

    render json: { trainers: trainers.map(&:to_h) }
  end

  def show
    @trainer = Trainer.find_by(id: trainer_id)

    if @trainer
      trainer = V1::TrainerPresenter.new(@trainer)

      render json: { trainer: trainer.to_h }
    else
      head(:not_found)
    end
  end

  private

  def trainer_id
    params[:id]
  end

  def expertise_filter
    params.permit(expertise: [])
  end
end
