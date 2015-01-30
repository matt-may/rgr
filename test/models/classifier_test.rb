require 'test_helper'
require 'classifier'
require 'csv'

class ClassifierTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @csv = CSV.table(fixture_file_upload('data.csv'))
    data = Hash[(%w|male female|.map { |gender| [gender, []] })]

    @csv.each do |row|
      data[row[:gender]] << [row[:height], row[:weight]]
    end

    @classifier = BayesClassifier.new data, 2
  end

  test 'feature set is properly returned' do
    assert_equal [600, 592, 558, 592], @classifier.feature_set(0, 'male')
    assert_equal [100, 150, 130, 150], @classifier.feature_set(1, 'female')
  end

  test 'classes are male and female' do
    classes = %w|male female|
    assert (@classifier.classes == classes) || (@classifier.classes = classes.reverse)
  end

  test 'should have 2 classes' do
    assert_equal @classifier.size, 2
  end

  test 'classify as male' do
    assert_equal 'male', @classifier.classify([670,200])
  end

  test 'classify as female' do
    assert_equal 'female', @classifier.classify([500,120])
  end
end