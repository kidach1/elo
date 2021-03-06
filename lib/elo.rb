require 'elo/helper'
require 'elo/configuration'
require 'elo/game'
require 'elo/player'
require 'elo/rating'

module Elo
  def self.config
    @config ||= Configuration.new
  end

  def self.configure(&block)
    yield(config)
  end
end
