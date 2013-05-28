$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'resque/server'
require 'ventriloquist'

run Rack::URLMap.new('/' => Ventriloquist::App, '/resque' => Resque::Server.new)
