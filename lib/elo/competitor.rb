module Elo
  class Competitor
    include Helper
    attr_accessor :rating
    attr_accessor :result_against_player # { 0: lose, 0.5: draw, 1: win }

    def initialize(rating, res)
      self.rating = rating
      self.result_against_player = res
    end
  end
end
