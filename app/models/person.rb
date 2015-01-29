class Person < ActiveRecord::Base
  enum gender: [:male, :female]
end
