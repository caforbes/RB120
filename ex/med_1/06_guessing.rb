class GuessingGame
  TOTAL_GUESSES = 7

  LOW_NUM = 1
  HIGH_NUM = 100

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

  attr_reader :guess, :number, :guesses_left

  def setup
    @guesses_left = 7
    @number = rand(LOW_NUM..HIGH_NUM)
  end

  def user_turn
    display_guesses_left
    get_user_guess
    @guesses_left -= 1
  end

  def get_user_guess
    loop do
      print "Enter a number between #{LOW_NUM} and #{HIGH_NUM}: "
      @guess = gets.chomp # validate number
      break if valid_number?(guess)
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

  def valid_number?(input)
    input == input.to_i.to_s && (LOW_NUM..HIGH_NUM).include?(input.to_i)
  end

  def winning_guess?
    guess == number
  end

  def no_more_guesses?
    guesses_left == 0
  end
end

game = GuessingGame.new
game.play