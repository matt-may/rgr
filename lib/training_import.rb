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
    def prepare_sql; raise "Define #prepare_sql in your subclass"; end

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

    private

    # Prepare the raw SQL statements inserting people into the
    # database
    def prepare_sql
      @sql = 'insert into people (' + @params.join(', ') + ') values '

      people.each_with_index do |person, i|
        person = person['person']
        gender = person['gender']
        person['gender'] = Person.genders[gender.downcase]

        # Select the values at our params
        values = person.values_at(*@params).map(&replace_nil)
        joined = values.join(', ')

        @sql += '(' + joined + ')'
        @sql += ', ' unless i+1 == people.size
      end
    end
  end
end