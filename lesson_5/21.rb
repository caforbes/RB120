require 'pry'

module Hand
  attr_reader :hand

  def new_card(card)
    hand[card] = card.value || ace_value
  end

  def busted?
    total > 21
  end

  def total
    hand.values.sum
  end

  def ==(other)
    total == other.total
  end

  def <(other)
    total < other.total
  end

  def >(other)
    total > other.total
  end

  def show_hand
    puts ""
    puts "#{name} has:"
    hand.each { |card, score| puts "#{card} (#{score} points)".center(40) }
    puts "Total: #{total}"
  end

  def show_top_card
    first_card = hand.keys.first
    cards_left = hand.size - 1
    puts ""
    puts "#{name} has:"
    puts "#{first_card} (#{hand[first_card]} points)".center(40)
    puts "...and #{cards_left} other card#{'s' if cards_left > 1}...".center(40)
  end

  def show_turn
    drawn = hand.size - 2
    puts "#{name} drew #{drawn} card#{'s' if drawn > 1}" +
          " for #{total} points#{' and busted' if busted?}."
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
    @stay = false
  end

  def stay!
    @stay = true
  end

  def stay?
    @stay
  end
end

class Player < Participant
  def initialize
    super
    @name = 'Unnamed Player'
  end

  def hit_or_stay
    puts ""
    choice = nil
    loop do
      puts "Would you like to (1) hit, or (2) stay?"
      choice = gets.chomp.to_i
      break if [1, 2].include?(choice)
      puts "That's not a valid option!"
    end
    stay! if choice == 2
  end
end

class Dealer < Participant
  def initialize
    super
    @name = 'Dealer'
  end

  def hit_or_stay
    stay! if total > 17
  end
end

class Deck
  FACES = (2..10).to_a + %w(A J Q K)
  SUITS = %w(♡ ♠ ♣ ♢)

  def initialize
    @cards = []
    FACES.each do |face|
      SUITS.each { |suit| @cards << Card.new(face, suit) }
    end
    @cards.shuffle!
  end

  def deal(player, num_of_cards)
    num_of_cards.times { player.new_card(@cards.shift) }
  end

  def hit(player)
    deal(player, 1)
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
  attr_reader :deck, :dealer, :player

  def initialize
    @dealer = Dealer.new
    @player = Player.new
  end

  def start
    deal_initial_cards
    show_cards
    player_turn
    dealer_turn
    show_result
  end

  def deal_initial_cards
    @deck = Deck.new
    deck.deal(player, 2)
    deck.deal(dealer, 2)
  end

  def player_turn
    until player.busted?
      player.hit_or_stay
      break if player.stay?
      deck.hit(player)
      show_cards
    end
  end

  def dealer_turn
    return if player.busted?

    until dealer.busted?
      dealer.hit_or_stay
      break if dealer.stay?
      deck.hit(dealer)
    end
    # need to figure out display of dealer hand/move
  end

  def calculate_winner
    if player.busted? then dealer
    elsif dealer.busted? then player
    elsif player > dealer then player
    elsif player < dealer then dealer
    end
  end

  def show_cards
    dealer.show_top_card
    player.show_hand
  end

  def show_result
    puts ""
    player.show_turn
    dealer.show_turn unless player.busted?
    player.show_hand
    dealer.show_hand
    puts ""
    show_winner
  end

  def show_winner
    case calculate_winner
    when player then puts "You won this round!!"
    when dealer then puts "The dealer won this round..."
    else puts "It was a tie."
    end
  end
end

Game.new.start
