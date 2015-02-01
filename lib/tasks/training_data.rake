require 'json'
require 'training_import'

namespace :training_data do
  desc 'Imports JSON training data and writes it to the `people` table'
  task :import, [:file] => :environment do |t, args|
    raise 'A JSON training file must be given as an argument' unless args[:file]

    file = File.expand_path(args[:file])
    import = Import::PeopleImport.new(file)
    result = import.result

    puts result
  end
end