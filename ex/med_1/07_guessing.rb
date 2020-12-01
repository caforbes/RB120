class GuessingGame
  def initialize(minimum, maximum)
    @min = minimum
    @max = maximum
  end

  def play
    setup
    loop do
      user_turn
      display_guess_feedback
      break if winning_guess? || no_more_guesses?
    end
    display_game_result
  end

  private

  attr_reader :min, :max, :guess, :number, :guesses_left

  def setup
    @guesses_left = calculate_total_guesses
    @number = rand(min..max)
    @guess = nil
  end

  def user_turn
    display_guesses_left
    get_user_guess
    @guesses_left -= 1
  end

  def get_user_guess
    loop do
      print "Enter a number between #{min} and #{max}: "
      @guess = gets.chomp
      break if valid_guess?
      puts "That's not a valid guess!"
    end
    @guess = guess.to_i
  end

  def display_guesses_left
    puts "You have #{guesses_left} guess#{'es' unless guesses_left == 1} remaining."
  end

  def display_guess_feedback
    if winning_guess?
      puts "That's it! That's the number!"
    elsif guess < number
      puts "Your guess is too low."
    elsif guess > number
      puts "Your guess is too high."
    end
    puts ""
  end

  def display_game_result
    puts ""
    if winning_guess?
      puts "You won!"
    else
      puts "Too bad. Better luck next time!"
    end
  end

  def calculate_total_guesses
    size_of_range = (min..max).to_a.size
    Math.log2(size_of_range).to_i + 1
  end

  def valid_guess?
    guess == guess.to_i.to_s && (min..max).include?(guess.to_i)
  end

  def winning_guess?
    guess == number
  end

  def no_more_guesses?
    guesses_left == 0
  end
end

game = GuessingGame.new(1, 600)
game.play
