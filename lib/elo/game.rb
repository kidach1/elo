module Elo
  class Game
    # http://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details

    include Helper
    attr_accessor :player
    attr_accessor :match_num
    K_FACTOR = 32

    def initialize(player, competitors)
      self.player = player
      self.match_num = competitors.length
      define_attr_competitor
      competitors.each.with_index(1) do |player, i|
        send("competitor#{i}=", player)
      end
    end

    def run
      Rating.new(
        result: player_score_sum,
        old_rating: player.rating,
        expected: expected_sum,
        k_factor: K_FACTOR
      ).new_rating
    end

    private

    def define_attr_competitor
      self.match_num.times.with_index(1) do |_, i|
        self.class.send :define_method, "competitor#{i}=" do |value|
          instance_variable_set("@competitor#{i}", value)
        end
      end
    end

    def competitors_score_sum
      c_scores = match_num.times.with_index(1).map do |_, i|
        instance_variable_get("@competitor#{i}").result_against_player
      end
      c_scores.inject(0.0) {|sum, score| sum += score}
    end

    def player_score_sum
      match_num.to_f - competitors_score_sum
    end

    def expected_sum
      p_rating = player.rating
      c_raitngs = match_num.times.with_index(1).map do |_, i|
        instance_variable_get("@competitor#{i}").rating
      end
      c_raitngs.inject(0.0) do |sum, c_rating|
        e = Rating.new(old_rating: p_rating, other_rating: c_rating).expected_al
        sum += e
      end
    end
  end
end
