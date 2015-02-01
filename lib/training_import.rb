module Import
  class TrainingImport
    # Read in our training data
    def initialize(file)
      @file = file
      @count = Person.count
    end

    # Read the provided file and parse it as JSON
    def parse
      file = File.read(@file)
      @data = JSON.parse(file)
    end

    # Proc that multiples the value by 100 if its numeric;
    # else just returns the value. Useful for converting floats
    # into ints, since our height & weight are Integer columns
    def times_100
      lambda { |val| val.is_a?(Numeric) ? (val*100).round : val }
    end

    # Replaces nil values with null
    def replace_nil
      lambda { |val| val.nil? ? 'NULL' : val }
    end

    private

    # Prepares a SQL statement and executes it
    def seed
      parse
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
    def initialize(file)
      super(file)
      @params = %w|height weight gender|
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

    # Gender is an enum, so find the correct integer and return it
    def set_gender gender
      case gender
        when 'Male'
          Person.genders[:male]
        when 'Female'
          Person.genders[:female]
        else nil
      end
    end

    private

    # Prepare the raw SQL statements inserting people into the
    # database
    def prepare_sql
      @sql = 'insert into people (' + @params.join(', ') + ') values '

      people.each_with_index do |person, i|
        person = person['person']
        person['gender'] = set_gender(person['gender'])

        values = person.values_at(*@params).map(&replace_nil) # Select the values at our params
        values[0..1] = values[0..1].map(&times_100) # Multiply the height & weight by 100

        joined = values.join(', ')

        @sql += '(' + joined + ')'
        @sql += ', ' unless i+1 == people.size
      end
    end
  end
end