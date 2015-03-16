module Elo
  class Player
    include Helper
    attr_accessor :rating
    attr_accessor :ranking

    def initialize(rating, ranking)
      self.rating = rating
      self.ranking = ranking
    end
  end
end
