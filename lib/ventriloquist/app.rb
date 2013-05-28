require 'bundler/setup'
Bundler.require :default

require 'resque'
require 'sinatra/base'

module Ventriloquist
  class App < Sinatra::Base
    configure do
      set :root, File.join(File.dirname(__FILE__), '..', '..')
    end

    get '/' do
      haml :index
    end

    post '/phrases' do
      if params[:phrase]
        Resque.enqueue Phrase, params[:phrase]
      end

      redirect to('/')
    end
  end
end
