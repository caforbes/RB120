module Displayable
  def orjoined(list)
    if list.size > 1 then "#{list[0..-2].join(', ')}, or #{list.last}"
    else list.join(', ')
    end
  end
end

class TTTGame
  include Displayable

  WINNING_SCORE = 2

  attr_reader :board, :human, :computer, :current_player, :scoreboard

  def initialize
    @board = Board.new
    @scoreboard = Scoreboard.new(WINNING_SCORE)
  end

  def play
    display_welcome_message
    setup
    display_ready_message
    set_of_games
    display_goodbye_message
  end

  private

  def setup
    @human = Human.new
    @computer = Computer.new
    @current_player = first_player
  end

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
    puts
  end

  def display_ready_message
    puts ""
    puts "Hi, #{human}! You have chosen the marker #{human.marker}."
    puts "Today you will be playing #{computer}."
    puts ""
    puts "The first to #{WINNING_SCORE} wins takes the match!"
    sleep 2
    puts "Ready, set, go!"
    sleep 1
    clear_screen
  end

  def display_goodbye_message
    puts
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def display_board
    scoreboard.draw
    puts "You are #{human.marker}. #{computer} is #{computer.marker}."
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
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
    puts "Choose an empty square (#{orjoined(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    square
  end

  def computer_move
    choice ||= board.third_consecutive_key(computer.marker) if computer.offense?
    choice ||= board.third_consecutive_key(human.marker) if computer.defense?
    choice ||= board.good_square if computer.smart?

    choice ? choice : board.unmarked_keys.sample
  end

  def change_current_player
    @current_player = alternate(current_player)
  end

  def alternate(player)
    case player
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
    when human.marker then scoreboard.add(human)
    when computer.marker then scoreboard.add(computer)
    end
  end

  def final_winner
    scoreboard.winner
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "You won, #{human}!"
    when computer.marker
      puts "#{computer} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_final_winner
    puts ""
    case final_winner
    when human
      puts "#{human}, you won this Best-of-#{WINNING_SCORE} match!!!!"
    when computer
      puts "#{computer} is the winner of this Best-of-#{WINNING_SCORE} match!!!"
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
    scoreboard.reset
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

      if has_this_marker?(current_squares, marker)
        remaining_square = current_squares.select(&:unmarked?).first
        return @squares.key(remaining_square)
      end
    end
    nil
  end

  def good_square
    MIDDLE if unmarked_keys.include?(MIDDLE)
  end

  private

  def num_in_a_row?(squares, num)
    markers = squares.reject(&:unmarked?).map(&:marker)
    markers.size == num && markers.uniq.size == 1
  end

  def has_this_marker?(squares, marker)
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
  DEFAULT_MARKERS = %w(X O ! - # + /)

  @@list = []

  attr_reader :marker, :score, :name

  def self.available_markers
    DEFAULT_MARKERS - taken_markers
  end

  def initialize
    @@list << self
    @score = 0
    @name = get_name
    @marker = choose_marker
  end

  def to_s
    name
  end

  def add_point
    @score += 1
  end

  def reset_score
    @score = 0
  end

  private

  def choose_marker
    Player.available_markers.first
  end

  def self.list
    @@list
  end

  def self.taken_markers
    Player.list.map(&:marker)
  end
end

class Human < Player
  private

  def get_name
    input = nil
    loop do
      puts "What's your name?"
      input = gets.chomp
      break unless input.empty?
      puts "I can't call you that!"
    end
    input
  end

  def choose_marker
    choice = nil
    loop do
      puts "Choose your tic-tac-toe marker: " +
        Player.available_markers.join(' ')
      choice = gets.chomp.upcase
      break if Player.available_markers.include?(choice)
      puts "You can't use that as a marker, sorry."
    end
    choice
  end
end

class Computer < Player
  COMPUTER_TYPES = {
    'Randombot' => [],
    'Rob' => ['offense'],
    'Bot' => ['defense'],
    'R2D2' => ['offense', 'defense'],
    'Baby Computer' => ['smart'],
    'Super Computer' => ['offense', 'defense', 'smart']
  }

  def initialize
    super
    @playstyle = COMPUTER_TYPES[name]
  end

  def get_name
    COMPUTER_TYPES.keys.sample
  end

  def defense?
    @playstyle.include?('defense')
  end

  def offense?
    @playstyle.include?('offense')
  end

  def smart?
    @playstyle.include?('smart')
  end
end

class Scoreboard
  def initialize(points_to_win)
    @max_points = points_to_win
    reset
  end

  def reset
    @scores = Hash.new(0)
  end

  def draw
    tally = @scores.map { |(name, pts)| "#{name} (#{pts})" }.join(' | ')
    puts "-------------------"
    puts "Scores: #{tally}"
    puts "-------------------"
  end

  def add(player)
    @scores[player] += 1
  end

  def winner
    @scores.key(@max_points)
  end
end

game = TTTGame.new
game.play
