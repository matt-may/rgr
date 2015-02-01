class Person < ActiveRecord::Base
  enum gender: { male: 0, female: 1 }
  scope :female, -> { where(gender: genders[:female]) }
  scope :male, -> { where(gender: genders[:male]) }

  validates :height, presence: true, numericality: true
  validates :weight, presence: true, numericality: true
end