require 'pry'

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
  end

  def play
    display_welcome_message
    display_board

    loop do
      human_moves
      break if board.someone_won? || board.full?
      # break if someone_won? || board_full?
      computer_moves
      break if board.someone_won? || board.full?
      # break if someone_won? || board_full?

      display_board
    end
    display_result
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts
  end

  def display_goodbye_message
    puts
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board # why is this in game not board?
    system('clear') || system('cls')
    puts "You are #{human.marker}. Computer is #{computer.marker}."

    puts "     |     |"
    puts "  #{board.get_square_at(1)}  |  #{board.get_square_at(2)}  |  #{board.get_square_at(3)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(4)}  |  #{board.get_square_at(5)}  |  #{board.get_square_at(6)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_square_at(7)}  |  #{board.get_square_at(8)}  |  #{board.get_square_at(9)}"
    puts "     |     |"
  end

  def display_result
    display_board

    case board.detect_winner
    when HUMAN_MARKER
      puts "You won!"
    when COMPUTER_MARKER
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def human_moves
    puts "Choose an empty square (#{board.unmarked_keys.join(', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board.set_square_at(square, human.marker)
  end

  def computer_moves
    num = board.unmarked_keys.sample

    board.set_square_at(num, computer.marker)
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]] # diags

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def get_square_at(key) # returns Square
    @squares[key]
  end

  def set_square_at(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!detect_winner
  end

  def detect_winner # returns winning marker or nil
    WINNING_LINES.each do |line|
      current_markers = @squares.values_at(*line).map(&:marker)

      if current_markers.all? {|marker| marker == TTTGame::HUMAN_MARKER }
        return TTTGame::HUMAN_MARKER
      elsif current_markers.all? {|marker| marker == TTTGame::COMPUTER_MARKER }
        return TTTGame::COMPUTER_MARKER
      end
      # if count_human_marker(current_squares) == 3
      #   return TTTGame::HUMAN_MARKER
      # elsif count_computer_marker(current_squares) == 3
      #   return TTTGame::COMPUTER_MARKER
      # end
    end
    nil
  end

  # def count_human_marker(squares)
  #   squares.collect(&:marker).count(TTTGame::HUMAN_MARKER)
  # end

  # def count_computer_marker(squares)
  #   squares.collect(&:marker).count(TTTGame::COMPUTER_MARKER)
  # end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

game = TTTGame.new
game.play
