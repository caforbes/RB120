require 'pry'

class TTTGame
  attr_reader :board, :human, :computer, :current_player

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_player = first_player
  end

  def play
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if humans_turn?
      end

      display_result
      break unless play_again?
      display_new_game_message
      reset
    end

    display_goodbye_message
  end

  def display_welcome_message
    clear_screen
    puts "Welcome to Tic Tac Toe!"
    puts
  end

  def display_goodbye_message
    puts
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def display_board
    puts "You are #{human.marker}. Computer is #{computer.marker}."
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def current_player_moves
    square = current_player.choose(board.unmarked_keys)
    board[square] = current_player.marker

    change_current_player
  end

  def change_current_player
    @current_player = case current_player
                      when human then computer
                      when computer then human
                      end
  end

  def humans_turn?
    current_player == human
  end

  def first_player
    human
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, please answer (y) or (n)."
    end

    answer == 'y'
  end

  def display_new_game_message
    clear_screen
    puts "Let's play again!"
    puts
  end

  def reset
    board.reset
    @current_player = first_player
  end

  def human_moves


    board[square] = human.marker
  end

  def computer_moves
    square = board.unmarked_keys.sample

    board[square] = computer.marker
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]] # diags

  def initialize
    @squares = {}
    reset
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker # returns winning marker or nil
    WINNING_LINES.each do |line|
      current_squares = @squares.values_at(*line)
      return current_squares.first.marker if three_in_a_row?(current_squares)
    end
    nil
  end

  private

  def three_in_a_row?(squares)
    markers = squares.reject(&:unmarked?).map(&:marker)
    markers.size == 3 && markers.uniq.size == 1
  end
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
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :marker
end

class Human < Player
  def initialize
    @marker = HUMAN_MARKER
  end

  def choose(possible_squares)
    puts "Choose an empty square (#{possible_squares.join(', ')}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if possible_squares.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    square
  end
end

class Computer < Player
  def initialize
    @marker = COMPUTER_MARKER
  end

  def choose(possible_squares)
    possible_squares.sample
  end
end

game = TTTGame.new
game.play
