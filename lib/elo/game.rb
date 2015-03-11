module Elo
  class Game
    # http://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details

    include Helper
    attr_accessor :player
    attr_accessor :match_num
    K_FACTOR = 32

    def initialize(player, *args)
      self.player = player
      self.match_num = args.length
      define_attr_competitor
      args.each.with_index(1) do |player, i|
        send("competitor#{i}=", player)
      end
    end

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
      c_scores.inject(0.0) {|r, s| r += s}
    end

    def player_score_sum
      match_num.to_f - competitors_score_sum
    end

    class << self
      def result_sum
        inject(0.0) {|r, player| r += player.result}
      end

      def expected_sum
        inject(0.0) do |r, player|
          e = Rating.new(old_rating: my_rating, other_rating: player[:rating]).expected_al
          r += e
        end
      end

      def wiki
        Rating.new(
          result: result_sum,
          old_rating: my_rating,
          expected: expected_sum,
          k_factor: K_FACTOR
        ).new_rating
      end
    end
  end
end
