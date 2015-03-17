require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '../../../lib/elo.rb')

def players(my_rating)
  my_rank, other_ratings = rand_rank_ratings(my_rating)
  other_ratings.map do |k, v|
    Elo::Player.new(k, v)
  end.unshift Elo::Player.new(my_rating, my_rank)
end

def rand_rank_ratings(my_rating)
  i = 1
  ratings = []
  while ratings.flatten.length != 6
    ratings = 5.times.map { rand(my_rating-30..my_rating+30) }
    ratings.push my_rating
  end
  rank_rating = ratings.sort.reverse.each_with_object({}) do |(k, v), h|
    h[k] = i
    i += 1
  end
  # => {1522=>1, 1521=>2, 1520=>3, 1506=>4, 1500=>5, 1490=>6}

  rand_rank_ratings = Hash[rank_rating.to_a.shuffle]
  my_rank = rand_rank_ratings[my_rating]

  rand_rank_ratings.delete(my_rating)
  return my_rank, rand_rank_ratings
end

require 'gnuplot'

j = 0
def execute(my_rating, j)
  return my_rating if j == 100
  ps = players(my_rating)
  game = Elo::Game.new(ps)
  new_rating = game.run.first
  j += 1
  execute(new_rating, j)
end

res = []
1000.times do |i|
  p i
  res << execute(1500, 0)
end
p res

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
    plot.title  'elo'
    plot.ylabel 'x'
    plot.xlabel 'y'
    plot.set "size ratio 1"
    plot.terminal("png")
    plot.output("y_eq_x2.png")
    plot.set "linestyle 1 linecolor rgbcolor 'blue' linetype 1"
    x = res
    y = 1..1000

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "lines ls 1"
      ds.linewidth = 4
      ds.notitle
    end
  end
end
