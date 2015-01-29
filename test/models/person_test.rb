require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "can create a person" do
    assert_nothing_raised do
      Person.create!(height: 10, weight: 20, gender: :male)
    end
  end
end
