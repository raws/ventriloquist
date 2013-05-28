require 'pusher'
require 'resque'
require 'sinatra/base'
require 'sinatra/config_file'

module Ventriloquist
  class App < Sinatra::Base
    register Sinatra::ConfigFile

    configure do
      config_file File.join(File.dirname(__FILE__), '..', '..', 'config.yml')

      set :root, File.join(File.dirname(__FILE__), '..', '..')

      Pusher.app_id = settings.pusher['app_id']
      Pusher.key = settings.pusher['key']
      Pusher.secret = settings.pusher['secret']
    end

    get '/' do
      @phrases = phrases
      haml :index
    end

    post '/phrases' do
      if params[:phrase]
        Resque.enqueue Phrase, params[:phrase]
      end

      redirect to('/')
    end

    def self.redis
      @redis ||= Redis::Namespace.new(:ventriloquist, redis: Redis.new)
    end

    private

    def phrases
      redis.lrange(:phrases, 0, 24).map do |json|
        hash = JSON.parse(json)
        Phrase.new text: hash['text'], time: Time.at(hash['time'].to_i)
      end.reverse
    end

    def redis
      self.class.redis
    end
  end
end
