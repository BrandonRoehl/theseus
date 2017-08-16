class CreateInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :instances, id: false do |t|
      t.string :key
      t.text :value
      t.references :model, foreign_key: true, null: false

      t.index [:key, :model_id], unique: true
    end
  end
end
