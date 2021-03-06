module Validate
  def has_characters?(input)
    !!(input =~ /^\s*$/)
  end

  def valid_int?(input_string)
    input_string.to_i.to_s == input_string
  end
end

class Card
  def initialize(face, suit)
    @face = face
    @suit = suit
  end

  def to_s
    "#{@face}#{suit}"
  end

  def suit
    case @suit
    when 'H' then '♡'
    when 'S' then '♠'
    when 'C' then '♣'
    when 'D' then '♢'
    end
  end

  def value(total)
    if %w(J Q K).include?(@face) then 10
    elsif (2..10).include?(@face) then @face
    else ace_value(total)
    end
  end

  def ace_value(total)
    total <= 10 ? 11 : 1
  end
end

class Deck
  FACES = (2..10).to_a + %w(A J Q K)
  SUITS = %w(H S C D)

  def initialize
    @cards = []
    FACES.each do |face|
      SUITS.each { |suit| @cards << Card.new(face, suit) }
    end
    @cards.shuffle!
  end

  def deal
    @cards.pop
  end
end

module Hand
  attr_reader :hand

  def new_card(card)
    hand[card] = card.value(total)
  end

  def busted?
    total > 21
  end

  def total
    hand.values.sum
  end

  def <(other)
    total < other.total
  end

  def >(other)
    total > other.total
  end

  def show_hand
    puts "#{name} has:"
    hand.each { |card, score| puts "#{card} (#{score} points)".center(40) }
    puts "Total: #{total}"
    puts ""
  end

  def show_turn
    drawn = hand.size - 2
    puts  "#{name} drew #{drawn} card#{'s' unless drawn == 1}" \
          " for #{total} points#{' and busted' if busted?}."
  end
end

class Participant
  include Hand

  attr_reader :name

  def initialize
    set_name
    reset
  end

  def reset
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
  def set_name
    input = nil
    loop do
      puts "What should I call you?"
      input = gets.chomp
      break unless has_characters?(input)
      puts "I can't call you that!"
    end
    @name = input
  end

  def hit_or_stay
    choice = nil
    loop do
      puts "Would you like to (1) hit, or (2) stay?"
      choice = gets.chomp
      choice = choice.to_i if valid_int?(choice)
      break if [1, 2].include?(choice)
      puts "That's not a valid option!"
    end
    stay! if choice. == 2
  end

  def show_cards
    show_hand
  end

  private

  include Validate
end

class Dealer < Participant
  def set_name
    @name = 'Dealerbot'
  end

  def hit_or_stay
    stay! if total > 17
  end

  def show_cards
    first_card = hand.keys.first
    cards_left = hand.size - 1
    puts "#{name} has:"
    puts "#{first_card} (#{hand[first_card]} points)".center(40)
    puts "...and #{cards_left} other card#{'s' if cards_left > 1}...".center(40)
    puts ""
  end
end

class Game
  attr_reader :deck, :dealer, :player

  def play
    show_welcome
    setup
    loop do
      show_ready_message
      play_one_hand
      break unless play_again?
      reset
    end
    show_goodbye
  end

  private

  def setup
    @dealer = Dealer.new
    @player = Player.new
    @deck = Deck.new
  end

  def reset
    @deck = Deck.new
    player.reset
    dealer.reset
  end

  def play_one_hand
    clear
    deal_initial_cards
    show_cards
    player_turn
    dealer_turn
    show_result
  end

  def deal_initial_cards
    2.times do
      player.new_card(deck.deal)
      dealer.new_card(deck.deal)
    end
  end

  def player_turn
    until player.busted?
      player.hit_or_stay
      break if player.stay?
      player.new_card(deck.deal)
      clear
      show_cards
    end
  end

  def dealer_turn
    return if player.busted?

    until dealer.busted?
      dealer.hit_or_stay
      break if dealer.stay?
      dealer.new_card(deck.deal)
    end
  end

  def calculate_winner
    if player.busted? then dealer
    elsif dealer.busted? then player
    elsif player > dealer then player
    elsif player < dealer then dealer
    end
  end

  # display and messages
  def show_welcome
    clear
    puts "Welcome to Twenty-One!"
    puts ""
  end

  def show_ready_message
    puts ""
    puts "Okay, let's deal!"
    sleep 1
    puts "..."
    sleep 1
  end

  def show_cards
    dealer.show_cards
    player.show_cards
  end

  def show_result
    sleep 1
    player.show_turn
    sleep 1
    dealer.show_turn unless player.busted?
    puts ""
    sleep 1
    show_winner
  end

  def show_winner
    puts "****************"
    case calculate_winner
    when player then puts "You won this round!!"
    when dealer then puts "The dealer won this round..."
    else puts "It was a tie."
    end
    puts "****************"
  end

  def play_again?
    input = nil
    loop do
      puts "Do you want to play again? (y/n)"
      input = gets.chomp
      break if ['y', 'n'].include?(input)
      puts "I didn't understand that answer!"
    end
    input == 'y'
  end

  def show_goodbye
    puts "Thanks for playing Twenty-One!"
  end

  def clear
    system 'clear' || 'cls'
  end
end

Game.new.play
