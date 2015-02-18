# Elo

From {Wikipedia}[http://en.wikipedia.org/wiki/Elo_rating_system]:

The Elo rating system is a method for calculating the relative skill levels of
players in two-player games such as chess and Go. It is named after its creator
Arpad Elo, a Hungarian-born American physics professor.

But Elo was designed for two player games.
This is for multi player games.

## Usage

WIP

## About the K-factor

The Elo rating system knows a variable called the "K-factor". The K-factor is used
to reward new talent and stableize the rating once a player is participating longer.

FIDE (the World Chess Foundation), gives players with less than 30 played games a
K-factor of 25. Normal players get a K-factor of 15 and pro's get a K-factor of 10.
Once you reach a pro status, you're K-factor never changes, even if your rating drops.

You need to provide Elo the amount of games played, their rating and their pro-status.

  bob = Elo::Player.new(:games_played => 29, :rating => 2399, :pro => true)
  bob.k_factor == 10

You can define your own K-factors by adding K-factor rules.
This code will change the K-factor to 12, for every player that played less than 10
games, and 16 for everybody else.

  Elo.configure do |config|
    config.k_factor(12) { games_played < 10 }
    config.default_k_factor = 16
    config.use_FIDE_settings = false
  end

## Installation

WIP

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.
