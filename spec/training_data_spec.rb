require 'spec_helper'
require 'rake'
require 'training_import'

describe 'training_data rake task' do
  before :all do
    # @rake = Rake::Application.new
    # Rake.application = @rake
    # Rake.application.rake_require "../../lib/tasks"
    # Rake::Task.define_task(:environment)
  end

  describe 'import' do
     before do
       #BarOutput.stub(:banner)
       #BarOutput.stub(:puts)

       puts 'hello'
     end

     let :run_rake_task do
        Rake::Task["training_data:import"].reenable
        Rake::Task["training_data:import[data/training2.json]"].invoke
     end

     it 'should return a string' do
       run_rake_task
       expect('1').to eq(result)
     end
  end
  #
  #   let :run_rake_task do
  #     Rake::Task["foo:bake_a_bar"].reenable
  #     Rake.application.invoke_task "foo:bake_a_bar"
  #   end
  #
  #   it "should bake a bar" do
  #     Bar.any_instance.should_receive :bake
  #     run_rake_task
  #   end
  #
  #   it "should bake a bar again" do
  #     Bar.any_instance.should_receive :bake
  #     run_rake_task
  #   end
  #
  #   it "should output two banners" do
  #     BarOutput.should_receive(:banner).twice
  #     run_rake_task
  #   end
  #
  # end
end