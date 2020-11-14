class Minilang
  def initialize(program)
    @stack = []
    @register = 0
    @program = program.split
  end

  def eval
    @program.each do |command|
      case validate(command)
      when :update then update(command.to_i)
      else send(validate(command))
      end
    end
    # for each item in program
    # identify if it is number, command, or invalid
      # if number, add to stack
      # if command, run command
      # if invalid, raise error
  end

  private

  VALID = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  attr_reader :stack, :register

  def update(n)

  end

  def push

  end

  def print
    puts register
  end

  def validate(command)
    if VALID.include?(command)
      command.downcase.to_sym
    elsif command.to_i.to_s == command
      :update
    else
      raise ArgumentError, "Invalid token: #{command}"
    end
  end
end

# split string into specific words
# interpret if word is number, command, or invalid

Minilang.new('PRINT').eval
# 0

# Minilang.new('5 PUSH 3 MULT PRINT').eval
# # 15

# Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# # 5
# # 3
# # 8

# Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# # 10
# # 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# # Empty stack!

# Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# # 6

# Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# # 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# # Invalid token: XSUB

# Minilang.new('-3 PUSH 5 SUB PRINT').eval
# # 8

# Minilang.new('6 PUSH').eval
# # (nothing printed; no PRINT commands)
