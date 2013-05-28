require 'shellwords'

module Ventriloquist
  class Phrase
    @queue = :phrases

    def initialize(text)
      @text = text
    end

    def self.perform(text)
      new(text).speak
    end

    def speak
      `/usr/bin/say #{@text.shellescape}`
    end
  end
end
