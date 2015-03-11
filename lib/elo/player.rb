module Elo
  class Player
    include Helper
    attr_accessor :rating

    def initialize(rating)
      self.rating = rating
    end
  end
end
