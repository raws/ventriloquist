require 'json'
require 'pusher'
require 'shellwords'

module Ventriloquist
  class Phrase
    @queue = :phrases
    
    attr_reader :id, :text, :time

    def initialize(params)
      @text = params[:text]
      @time = params[:time] || Time.now.utc
      @id = params[:id] || Digest::SHA1.hexdigest(text + time.to_i.to_s)
    end

    def log
      redis.pipelined do
        redis.lpush :phrases, to_json
        redis.ltrim :phrases, 0, 24
      end
    end

    def self.perform(text)
      phrase = new(text: text)
      phrase.log
      phrase.push
      phrase.speak
    end

    def push
      Pusher['phrases'].trigger('phrase.spoken', to_hash)
    end

    def redis
      App.redis
    end

    def speak
      `/usr/bin/say #{text.shellescape}`
    end
    
    private
    
    def to_hash
      { id: id, text: text, time: time.to_i }
    end
    
    def to_json
      JSON.dump(to_hash)
    end
  end
end
