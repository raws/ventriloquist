require 'bundler/setup'
Bundler.require :default

require './lib/ventriloquist'
require 'resque/tasks'

task 'resque:setup' do
  ENV['QUEUE'] = '*'
end
