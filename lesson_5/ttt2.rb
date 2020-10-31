class TTTGame
  WINNING_SCORE = 3

  attr_reader :board, :human, :computer, :current_player, :final_winner

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_player = first_player
  end

  def play
    display_welcome_message
    set_of_games
    display_goodbye_message
  end

  private

  def set_of_games
    loop do
      main_game
      display_final_winner
      break unless play_again?
      display_new_game_message
      reset
      reset_scores
    end
  end

  def main_game
    loop do
      display_leader_message
      display_board
      players_move
      update_scores
      display_result
      break if final_winner || quit?
      reset
      clear_screen
    end
  end

  def players_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if humans_turn?
    end
  end

  def display_welcome_message
    clear_screen
    puts "Welcome to Tic Tac Toe!"
    puts "The first to #{WINNING_SCORE} wins takes the match!"
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

  def string_of_keys
    keys = board.unmarked_keys

    if keys.size < 2 then keys.join(', ')
    else "#{keys[0..-2].join(', ')}, or #{keys.last}"
    end
  end

  def current_player_moves
    chosen_square = case current_player
                    when human then human_move
                    when computer then computer_move
                    end
    board[chosen_square] = current_player.marker

    change_current_player
  end

  def human_move
    puts "Choose an empty square (#{string_of_keys}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    square
  end

  def computer_move
    best_choice ||= board.third_consecutive_key(computer.marker) # offense
    best_choice ||= board.third_consecutive_key(human.marker) # defense
    best_choice ||= Board::MIDDLE if board.unmarked_keys.include?(Board::MIDDLE)

    return best_choice if best_choice
    board.unmarked_keys.sample
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

  def update_scores
    case board.winning_marker
    when human.marker then human.add_point
    when computer.marker then computer.add_point
    end
  end

  def final_winner
    if human.score == WINNING_SCORE then human
    elsif computer.score == WINNING_SCORE then computer
    end
  end

  def display_scores
    puts "-------------------"
    puts "Scores: You (#{human.score}) | Computer (#{computer.score})"
    puts "-------------------"
  end

  def display_leader_message
    if human.score < computer.score
      puts "The computer is in the lead!"
    elsif computer.score < human.score
      puts "You are in the lead!"
    end
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
    display_scores
  end

  def display_final_winner
    puts ""
    case final_winner
    when human
      puts "You won this Best-of-#{WINNING_SCORE} match!!!!"
    when computer
      puts "The computer won this time!!!!"
    else
      puts "There was no winner in this Best-of-#{WINNING_SCORE} match."
    end
    puts ""
  end

  def quit?
    answer = nil
    loop do
      puts "Ready for the next game? (n to exit)"
      answer = gets.chomp.downcase
      break
    end
    answer == 'n'
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
    puts "Let's play again to #{WINNING_SCORE} points!"
    puts
  end

  def reset
    board.reset
    @current_player = first_player
  end

  def reset_scores
    human.reset_score
    computer.reset_score
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]] # diags

  MIDDLE = 5

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
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
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

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
      return current_squares.first.marker if num_in_a_row?(current_squares, 3)
    end
    nil
  end

  def third_consecutive_key(marker)
    WINNING_LINES.each do |line|
      current_squares = @squares.values_at(*line)
      next unless num_in_a_row?(current_squares, 2)

      if has_marker?(current_squares, marker)
        unmarked_square = current_squares.select(&:unmarked?).first
        return @squares.key(unmarked_square)
      end
    end
    nil
  end

  private

  def num_in_a_row?(squares, num)
    markers = squares.reject(&:unmarked?).map(&:marker)
    markers.size == num && markers.uniq.size == 1
  end

  def has_marker?(squares, marker)
    squares.map(&:marker).include?(marker)
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

  attr_reader :marker, :score

  def initialize
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
  def initialize
    super
    @marker = HUMAN_MARKER
  end
end

class Computer < Player
  def initialize
    super
    @marker = COMPUTER_MARKER
  end
end

game = TTTGame.new
game.play
