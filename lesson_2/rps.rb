class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  def display_welcome_message
    puts "Hi, #{human.name}! Welcome to Rock, Paper, Scissors!"
    puts "Today you are playing against #{computer.name}."
  end

  def display_goodbye_message
    puts "Goodbye, #{human.name}! Thanks for playing Rock, Paper, Scissors!"
  end

  def display_winner
    puts "You chose #{human.move}!"
    puts "#{computer.name} chose #{computer.move}!"

    case
    when human.move.defeats?(computer.move)
      puts "You won!"
    when computer.move.defeats?(human.move)
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, please enter y or n."
    end
    answer == 'y'
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def defeats?(other)
    if rock? then other.scissors?
    elsif scissors? then other.paper?
    elsif paper? then other.rock?
    end
  end

  def rock?
    @value == Move::VALUES[0] # rock
  end

  def paper?
    @value == Move::VALUES[1] # paper
  end

  def scissors?
    @value == Move::VALUES[2] # scissors
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
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
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["Computer", "R2D2", "C3P0"].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

RPSGame.new.play
