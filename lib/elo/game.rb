module Elo
	# A Game is a collection of two Elo::Player objects
	# and a result.
	# Once the result is known, it propagates the new
	# ratings to the players.
  class Game
    include Helper

		# The result is the result of the match. It's a nubmer
		# from 0 to 1 from the perspective of player +:one+.
    attr_reader :result
  end
end
