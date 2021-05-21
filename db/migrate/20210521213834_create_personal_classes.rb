class CreatePersonalClasses < ActiveRecord::Migration[6.1]
  def change
    create_table :personal_classes do |t|
      t.references :trainer, null: false, foreign_key: true
      t.references :trainee, null: false, foreign_key: true
      t.datetime :started_at

      t.timestamps
    end
  end
end
