module Elo
  class Game
    # http://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details

    include Helper
    attr_accessor :player_cnt
    K_FACTOR = 32

    def initialize(players)
      self.player_cnt = players.length
      define_attr_player
      players.each.with_index(1) do |player, i|
        send("player#{i}=", player)
      end
    end

    def run
      self.player_cnt.times.map.with_index(1) do |_, i|
        Rating.new(
          result: score_sum(i),
          old_rating: instance_variable_get("@player#{i}").rating,
          expected: expected_sum(i),
          k_factor: K_FACTOR
        ).new_rating
      end
    end

    private

    def define_attr_player
      self.player_cnt.times.with_index(1) do |_, i|
        self.class.send :define_method, "player#{i}=" do |value|
          instance_variable_set("@player#{i}", value)
        end
      end
    end

    def score_sum(player_number)
      my_ranking = instance_variable_get("@player#{player_number}").ranking
      score = 0
      self.player_cnt.times.with_index(1) do |_, i|
        next if i == player_number
        score += ranking2score(my_ranking, instance_variable_get("@player#{i}").ranking)
      end
      score
    end

    def ranking2score(my_ranking, other_ranking)
      if my_ranking < other_ranking
        1
      elsif my_ranking > other_ranking
        0
      else
        0.5
      end
    end

    def expected_sum(player_number)
      my_rating = instance_variable_get("@player#{player_number}").rating
      es = 0
      self.player_cnt.times.with_index(1) do |_, i|
        next if i == player_number
        es += Rating.new(
          old_rating: my_rating,
          other_rating: instance_variable_get("@player#{i}").rating
        ).expected_al.round(3)
      end
      es
    end
  end
end
