class ChangePeopleColumnTypes < ActiveRecord::Migration
  def change
    change_column :people, :height, :float
    change_column :people, :weight, :float
  end
end
