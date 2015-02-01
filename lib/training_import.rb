module Import
  class TrainingImport
    # Read in our training data
    def initialize(file)
      file = File.read(file)
      @data = JSON.parse(file)
      @count = Person.count
    end

    # Sanitizes input
    def sanitize
      lambda { |val| ActiveRecord::Base::sanitize(val) }
    end

    # Proc that multiples the value by 100 if its numeric;
    # else just returns the value. Useful for converting floats
    # into ints, since our height & weight are Integer columns
    def times_100
      lambda { |val| val.is_a?(Numeric) ? val*100 : val }
    end

    private

    # Prepares a SQL statement and executes it
    def seed
      prepare_sql
      execute_sql
    end

    # Make sure to define in your subclass
    def prepare_sql; end

    # Executes a raw SQL statement
    def execute_sql
      ActiveRecord::Base.connection.execute(@sql)
    end
  end

  class PeopleImport < TrainingImport
    # Specify a file, model name, and set of params
    def initialize(file, model, *params)
      super(file)
      @params = params
    end

    # Retrieves an array of people from our parsed data.
    # Our parsed data takes the form:
    #   { 'people' => [
    #        'person' => {},
    #        'person' => {}
    #     ]
    #   }
    def people
      @data['people']
    end

    # Prepare a human-readable result; alert the user of how
    # many people have been added.
    def result
      seed
      new_count = Person.count
      added = new_count - @count
      "#{added} new people added to the database."
    end

    private

    # Prepare the raw SQL statements inserting people into the
    # database
    def prepare_sql
      @sql = 'insert into people (' + @params.join(', ') + ') values '

      people.each_with_index do |person, i|
        person = person['person']

        values = person.values_at(*@params)
        mult_by_100 = values.map(&times_100).map(&sanitize)
        joined = mult_by_100.join(', ').downcase

        @sql += '(' + joined + ')'
        @sql += ', ' unless i+1 == people.size
      end
    end
  end
end