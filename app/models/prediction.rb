class Prediction < ActiveRecord::Base
  validates :height, presence: true
  validates :weight, presence: true
end
