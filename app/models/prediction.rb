class Prediction < ActiveRecord::Base
  validates :height, presence: true, numericality: true
  validates :weight, presence: true, numericality: true
end
