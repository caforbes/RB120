class RPSGame
  attr_reader :human, :computer, :final_winner

  MAX_SCORE = 3

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      play_game_rounds until final_winner
      display_final_winner
      break unless play_again?
      reset_scores
    end
    display_goodbye_message
  end

  def play_game_rounds
    clear_and_continue
    human.choose
    computer.choose
    display_moves
    display_winner
    calculate_wins
    display_current_scores
  end

  def display_welcome_message
    puts "Hi, #{human.name}! Welcome to #{game_title}!"
    puts "Today you are playing against #{computer.name}."
    puts "The first to #{MAX_SCORE} points wins!"
  end

  def display_goodbye_message
    puts "Goodbye, #{human.name}! Thanks for playing #{game_title}!"
  end

  def game_title
    Move::VALUES.map(&:capitalize).join(', ')
  end

  def clear_and_continue
    puts "Ready? Press enter for the next round."
    gets.chomp
    system('clear') || system('cls')
  end

  def display_moves
    puts "You chose #{human.move}!"
    puts "#{computer.name} chose #{computer.move}!"
  end

  def display_winner
    if human.move.defeats?(computer.move)
      puts "You won this round!"
    elsif computer.move.defeats?(human.move)
      puts "#{computer.name} won this round!"
    else
      puts "It's a tie!"
    end
  end

  def calculate_wins
    update_scores
    set_winner
  end

  def update_scores
    if human.move.defeats?(computer.move)
      human.add_point
    elsif computer.move.defeats?(human.move)
      computer.add_point
    end
  end

  def set_winner
    @final_winner = if human.score >= MAX_SCORE then human
                    elsif computer.score >= MAX_SCORE then computer
                    end
  end

  def reset_scores
    human.reset_score
    computer.reset_score
    set_winner
  end

  def display_current_scores
    puts "========================"
    puts "CURRENT SCORES:"
    puts "#{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
    puts "========================"
  end

  def display_final_winner
    puts "\nTHE FINAL WINNER IS **#{final_winner.name.upcase}**!!!!\n"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, please enter y or n."
    end

    answer == 'y'
  end
end

class Player
  attr_accessor :move, :name
  attr_reader :score

  def initialize
    set_name
    @score = 0
  end

  def add_point
    @score += 1
  end

  def reset_score
    @score = 0
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, please enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose a move:"
      puts Move.numbered_options
      choice = Move.convert_numeric_choice(gets.chomp)
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.make(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["Computer", "R2D2", "C3P0"].sample
  end

  def choose
    self.move = Move.make(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  attr_reader :type

  def initialize
    @type = self.class.to_s.downcase
  end

  def to_s
    @type
  end

  def self.make(choice)
    case choice
    when VALUES[0] then Rock.new
    when VALUES[1] then Paper.new
    when VALUES[2] then Scissors.new
    when VALUES[3] then Lizard.new
    when VALUES[4] then Spock.new
    end
  end

  def self.numbered_options
    VALUES.map.with_index do |option, index|
      "(#{index + 1}) #{option}"
    end
  end

  def self.convert_numeric_choice(input)
    if input == input.to_i.to_s && (1..VALUES.length).include?(input.to_i)
      VALUES[input.to_i - 1]
    else
      input
    end
  end
end

class Rock < Move
  def defeats?(other)
    other.is_a?(Scissors) || other.is_a?(Lizard)
  end
end

class Paper < Move
  def defeats?(other)
    other.is_a?(Rock) || other.is_a?(Spock)
  end
end

class Scissors < Move
  def defeats?(other)
    other.is_a?(Paper) || other.is_a?(Lizard)
  end
end

class Lizard < Move
  def defeats?(other)
    other.is_a?(Spock) || other.is_a?(Paper)
  end
end

class Spock < Move
  def defeats?(other)
    other.is_a?(Rock) || other.is_a?(Scissors)
  end
end

RPSGame.new.play
