class MinilangError < StandardError ; end
class BadTokenError < MinilangError ; end
class EmptyStackError < MinilangError ; end

class Minilang
  VALID = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)

  def initialize(program)
    @stack = []
    @register = 0
    @program = program.split
  end

  def eval
    @program.each { |token| evaluate_token(token) }
  rescue MinilangError => e
    puts e.message
  end

  private

  attr_reader :stack, :register

  def evaluate_token(token)
    if VALID.include?(token)
      command = token.downcase.to_sym
      check_stack unless [:print, :push].include?(command)
      send(command)
    elsif token.to_i.to_s == token
      @register = token.to_i
    else
      raise BadTokenError, "Invalid token: #{command}"
    end
  end

  def check_stack
    if stack.size < 1
      raise EmptyStackError, "Empty stack!"
    end
  end

  def print
    puts register
  end

  def push
    stack << register
  end

  def pop
    @register = stack.pop
  end

  # all of these could be changed to pop instead of stack.pop -- eval on right side -- efficient, but ambiguous
  def add
    @register += stack.pop
  end

  def sub
    @register -= stack.pop
  end

  def mult
    @register *= stack.pop
  end

  def div
    @register /= stack.pop
  end

  def mod
    @register %= stack.pop
  end

  def num(n)
    @register = n
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
