# frozen_string_literal: true

class CreateTrainers < ActiveRecord::Migration[6.1]
  def change
    create_table :trainers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :expertise

      t.timestamps
    end
  end
end
