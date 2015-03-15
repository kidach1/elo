module Elo
  class Player
    include Helper
    attr_accessor :rating
    attr_accessor :rank

    def initialize(rating, rank)
      self.rating = rating
      self.rank = rank
    end
  end
end
