require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
end
