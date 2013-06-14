require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/locode'
  t.test_files = FileList['test/lib/**/*_test.rb', 'test/*_test.rb']
  t.verbose = true
end

desc "Update the datasource of the gem from csv files"
task :dataupdate do
  require './data/locode_data_update'
  puts "updating data"
  LocodeDataUpdate.new.parse
  puts "end of data update"
end

task :default => :test
