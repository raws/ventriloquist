$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'ventriloquist'
require 'resque/tasks'

task 'resque:setup' do
  ENV['QUEUE'] = '*'
end
