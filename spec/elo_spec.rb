require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
# require File.expand_path(File.dirname(__FILE__) + '../../lib/elo/competitor.rb')

describe "Elo" do
  after do
    Elo.instance_eval { @config = nil }
  end

  describe 'for multi player' do
    let(:game) do
      [
        {user: 'alice', result: 0, rating: 1609},
        {user: 'alice', result: 0.5, rating: 1477},
        {user: 'alice', result: 1, rating: 1388},
        {user: 'alice', result: 1, rating: 1586},
        {user: 'alice', result: 0, rating: 1720},
      ]
    end
    let(:my_rating) { 1613 }
    let(:k_factor) { 32 }

    before do
      # test  = Elo::Player.new(rating: 1500)
      # test.add_game_results(r)
    end

    describe 'kochi-way' do
      it do
        # ---------------------------
        #  kochi way
        # ---------------------------

        res_kochi = game.inject(0.0) do |r, c|
          e = Elo::Rating.new(
            result: c[:result],
            old_rating: my_rating,
            other_rating: c[:rating],
            k_factor: k_factor
          ).new_rating
          r += e
        end / game.size

        expect(res_kochi).to eq(1610)
      end
    end
    describe 'wikipedia-way' do
      it do
        # ---------------------------
        #  wikipedia way
        # ---------------------------

        result_sum = game.inject(0.0) {|r, c| r += c[:result]}
        expected_sum = game.inject(0.0) do |r, c|
          e = Elo::Rating.new(old_rating: my_rating, other_rating: c[:rating]).expected_al
          r += e
        end
        res_wiki = Elo::Rating.new(
          result: result_sum,
          old_rating: my_rating,
          expected: expected_sum,
          k_factor: k_factor
        ).new_rating

        expect(res_wiki).to eq(1601)
      end
    end

    describe 'wikipedia-way' do
      it do
        # ---------------------------
        #  wikipedia way
        # ---------------------------

        game = Elo::Game.new(
          Elo::Player.new(1613),
          Elo::Competitor.new(1609, 1),
          Elo::Competitor.new(1477, 0.5),
          Elo::Competitor.new(1388, 0),
          Elo::Competitor.new(1586, 0),
          Elo::Competitor.new(1720, 1)
        )


        # result_sum = game.inject(0.0) {|r, c| r += c[:result]}
        # expected_sum = game.inject(0.0) do |r, c|
        #   e = Elo::Rating.new(old_rating: my_rating, other_rating: c[:rating]).expected_al
        #   r += e
        # end
        # res_wiki = Elo::Rating.new(
        #   result: result_sum,
        #   old_rating: my_rating,
        #   expected: expected_sum,
        #   k_factor: k_factor
        # ).new_rating

        expect(game.competitors_score_sum).to eq(2.5)
      end
    end
  end
end
