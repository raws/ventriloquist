$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'resque/server'
require 'talkative'

run Rack::URLMap.new('/' => Talkative::App, '/resque' => Resque::Server.new)
