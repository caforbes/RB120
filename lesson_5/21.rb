require 'pry'

module Hand
  attr_reader :hand

  def new_card(card)
    hand[card] = card.value || ace_value
  end

  def busted?
  end

  def total
    hand.values.sum
  end

  def show_hand
    puts ""
    puts "#{name} has:"
    hand.each { |card, score| puts "#{card} (#{score} points)".center(40) }
    puts "Total: #{total}"
  end

  def show_one_card
    first_card = hand.keys.first
    rest_size = hand.size - 1
    puts ""
    puts "#{name} has:"
    puts "#{first_card} (#{hand[first_card]} points)".center(40)
    puts "...and #{rest_size} other card#{'s' if rest_size > 1}...".center(40)
  end

  private

  def ace_value
    total <= 10 ? 11 : 1
  end
end

class Participant
  include Hand

  attr_reader :name

  def initialize
    @hand = {}
  end
end

class Player < Participant
  def initialize
    # what would the "data" or "states" of a Player object entail?
    # maybe cards? a name?
    super
    @name = 'Unnamed Player'
  end

  def hit
  end

  def stay
  end
end

class Dealer < Participant
  def initialize
    super
    @name = 'Dealer'
  end

  def hit
  end

  def stay
  end
end

class Deck
  FACES = (2..10).to_a + %w(A J Q K)
  # SUITS = %w(hearts spades clubs diamonds)
  SUITS = %w(♡ ♠ ♣ ♢)

  def initialize
    @cards = []
    FACES.each do |face|
      SUITS.each { |suit| @cards << Card.new(face, suit) }
    end
    @cards.shuffle!
  end

  def deal(player, num_of_cards = 1)
    num_of_cards.times { player.new_card(@cards.shift) }
  end

  def count # for testing
    @cards.size
  end
end

class Card
  def initialize(face, suit)
    @face = face
    @suit = suit
  end

  def to_s
    "#{@face}#{@suit}"
  end

  def value
    if %w(J Q K).include?(@face) then 10
    elsif (2..10).include?(@face) then @face
    end
  end
end

class Game
  attr_reader :deck, :dealer, :human

  def initialize
    @dealer = Dealer.new
    @human = Player.new
  end

  def start
    deal_cards
    show_initial_cards
    # player_turn
    # dealer_turn
    # show_result
    # binding.pry
  end

  def deal_cards
    @deck = Deck.new
    deck.deal(human, 2)
    deck.deal(dealer, 2)
  end

  def show_initial_cards
    human.show_hand
    dealer.show_one_card
  end
end

Game.new.start
