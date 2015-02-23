require 'descriptive_statistics'

module BayesClassifier
  class Classifier
    # Takes training data of the format:
    #   {
    #      <CLASS_1>: [
    #                       [feature1, feature2, ..., feature_n],
    #                       [feature1, feature2, ..., feature_n]
    #                 ],
    #
    #      <CLASS_2>: [
    #                       [feature1, feature2, ..., feature_n],
    #                       [feature1, feature2, ..., feature_n]
    #                 ]
    #   }
    #
    # Params:
    # +training_data+:: +Hash+ of arrays of arrays
    # +dimension+:: Dimensionality of the training data
    #
    def initialize(training_data, dimension)
      @data = training_data
      @dimension = dimension
    end

    # Returns an array of class names from @data.
    def classes
      @data.keys
    end

    # Returns an array of values that a feature takes for a particular class
    # in the training data.
    #
    # Params:
    # +index+:: Desired index to consider
    # +class_name+:: Specified class name
    #
    def feature_set(index, class_name)
      training_set = @data[class_name]
      feature_set = training_set.map { |elem| elem[index] }

      # Give back the feature set
      feature_set
    end

    # Returns the probability of a value occurring for a certain feature in
    # a particular class.
    #
    # Params:
    # +value+:: Value to be tested
    # +index+:: Index of the relevant feature in the training data
    # +class_name+:: Specified class name
    #
    def feature_probability(value, index, class_name)
      # Assemble the feature set for the given class
      fs = feature_set(index, class_name)

      # Compute the stdev, mean, and variance of the feature
      fs_std = fs.standard_deviation
      fs_mean = fs.mean
      fs_var = fs.variance

      # Handle if the standard deviation is zero
      if fs_std == 0
        # Return 1.0 if the given value is equal to the mean of the
        # feature set; else 0.0
        return fs_mean == value ? 1.0 : 0.0
      end

      # Compute the Gaussian probability
      pi = Math::PI
      e = Math::E
      exp = -( (value - fs_mean) ** 2) / ( 2 * fs_var )
      prob = ( 1.0 / (Math.sqrt(2 * pi * fs_var) ) ) * ( e ** exp )

      # Return the probability
      prob
    end

    # Compute the product of all of the feature probabilities for an
    # array of feature values
    #
    # Params:
    # +feature_values+:: +Array+ of feature values
    # +class_name+:: Specified class name
    #
    def feature_multiply(feature_values, class_name)
      prod = feature_values.each_with_index.inject(1) do |accum, (elem, iter)|
        accum * feature_probability(elem, iter, class_name)
      end

      # Return the product
      prod
    end

    # Computes the probability of an array of values occurring for a
    # given class
    #
    # Params:
    # +feature_values+:: +Array+ of feature values
    # +class_name+:: Specified class name
    #
    def class_probability(feature_values, class_name)
      frac = 1.0 / classes.size
      prob = frac * feature_multiply(feature_values, class_name)

      # Return the probability
      prob
    end

    # Returns the probable class for an array of feature values
    #
    # Params:
    # +feature_values+:: +Array+ of feature values
    #
    def classify(feature_values)
      # Create a lambda that tests the probability of the feature values
      # occurring in each of the classes
      prob = -> (class_name) { class_probability(feature_values, class_name) }

      # Sort by the probabilities, so the most likely class is last
      class_name = classes.sort_by(&prob).last

      # Return the class name
      class_name
    end
  end

  class Trainer
    def initialize
      @data = Hash[(%w|male female|.map { |gender| [gender, []] })]

      Person.all.each do |person|
        @data[person.gender] << [person.height, person.weight]
      end
    end

    def trained
      BayesClassifier::Classifier.new @data, 2
    end
  end
end