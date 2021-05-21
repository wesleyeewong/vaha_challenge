# frozen_string_literal: true

class V1::TrainersController < ApplicationController
  def index
    @trainers = if index_params.present?
                  Trainer.where(expertise: index_params[:expertise])
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

  def index_params
    params.permit(expertise: [])
  end
end
