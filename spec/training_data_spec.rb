require 'spec_helper'
require 'rails_helper'
require 'rake'
require 'training_import'

describe 'training_data rake task' do
  before :all do
    @rake = Rake::Application.new
    Rake.application = @rake
    Classifier::Application.load_tasks
    Rake::Task.define_task(:environment)
  end

  describe 'import' do
    # Training 2 contains a small subset of the data from the Gist
    let(:valid_file) { 'training2.json' }
    let(:invalid_file) { 'no.json' }

    before(:each) do
      Rake::Task['training_data:import'].reenable
    end

    let :run_rake_task do
      Rake::Task['training_data:import'].invoke(Rails.root.join('data', valid_file))
    end

    let :run_rake_task_with_invalid_file do
      Rake::Task['training_data:import'].invoke(Rails.root.join('data', invalid_file))
    end

    # Ensure two records are added to the people table
    it 'adds two new records to the correct table' do
      expect { run_rake_task }.to change(Person, :count).by(2)
    end

    it 'does not raise any exceptions' do
      expect { run_rake_task }.not_to raise_error
    end

    it 'prints a result to STDOUT' do
      expect { run_rake_task }.to output("2 new people added to the database.\n").to_stdout
    end

    it 'raises the expected error with an invalid file' do
      expect { run_rake_task_with_invalid_file }.to raise_error(Errno::ENOENT)
    end

    it 'alerts the user if no argument is provided' do
      expect { Rake::Task['training_data:import'].invoke }.to raise_error(RuntimeError)
    end
  end
end