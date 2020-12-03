class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    reshuffle!
  end

  def draw
    reshuffle! if @cards.empty?
    @cards.pop
  end

  def reshuffle!
    @cards = RANKS.product(SUITS)
    @cards.map! { |(rank, suit)| Card.new(rank, suit) }
    @cards.shuffle!
  end
end

class Card
  include Comparable

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other)
    rank_value <=> other.rank_value
  # rescue NoMethodError
  #   super
  end

  protected

  def rank_value
    case rank
    when Integer then rank
    when "Jack" then 11
    when "Queen" then 12
    when "King" then 13
    when "Ace" then 14
    end
  end
end

deck = Deck.new

drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.
