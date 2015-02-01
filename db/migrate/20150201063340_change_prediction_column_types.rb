class ChangePredictionColumnTypes < ActiveRecord::Migration
  def change
    change_column :predictions, :height, :float
    change_column :predictions, :weight, :float
  end
end
