require 'bundler/setup'
Bundler.require :default

require './lib/talkative'
require 'resque/tasks'

task 'resque:setup' do
  ENV['QUEUE'] = '*'
end
