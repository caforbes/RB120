class Player
  def initialize
    # what would the "data" or "states" of a Player object entail?
    # maybe cards? a name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end

class Dealer
  def initialize
    # seems like very similar to Player... do we even need this?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Participant
  # what goes in here? all the redundant behaviors from Player and Dealer?
end

class Deck
  FACES = (1..10).to_a + %w(A J Q K)
  # SUITS = %w(hearts spades clubs diamonds)
  SUITS = %w(♡ ♠ ♣ ♢)

  def initialize
    @cards = []
    FACES.each do |face|
      SUITS.each { |suit| @cards << Card.new(face, suit) }
    end
    # obviously, we need some data structure to keep track of cards
    # array, hash, something else?
  end

  def deal
    # does the dealer or the deck deal?
  end
end

class Card
  def initialize(face, suit)
    @face = face
    @suit = suit
    @value = initial_value
  end

  def initial_value
    if %w(J Q K).include?(@face) then 10
    elsif (1..10).include?(@face) then @face
  end

  # def ace_value(current_total)

  # end
end

class Game
  def start
    deal_cards
    # show_initial_cards
    # player_turn
    # dealer_turn
    # show_result
  end

  def deal_cards
    @deck = Deck.new
  end
end

Game.new.start
