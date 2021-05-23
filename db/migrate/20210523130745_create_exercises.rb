# frozen_string_literal: true

class CreateExercises < ActiveRecord::Migration[6.1]
  def change
    create_table :exercises do |t|
      t.string :slug, uniqe: true, null: false

      t.timestamps
    end
  end
end
