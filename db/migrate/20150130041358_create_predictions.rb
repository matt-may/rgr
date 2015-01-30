class CreatePredictions < ActiveRecord::Migration
  def change
    create_table :predictions do |t|
      t.integer :height
      t.integer :weight
      t.string :result

      t.timestamps
    end
  end
end
