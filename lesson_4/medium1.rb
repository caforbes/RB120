class InvoiceEntry
  attr_reader :quantity, :product_name
  attr_writer :quantity

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    self.quantity = updated_count if updated_count >= 0
  end
end

# If quantity reference problem fixed with a setter method, caution! the setter
# is public, which means the point of the controls in update_quantity can be
# circumvented and the variable publicly accessed.


class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.new.hi
Goodbye.new.bye


class KrispyKreme
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    donut_type
  end

  def donut_type
    filling = @filling_type ? @filling_type : "Plain"
    topping = @glazing ? " with #{@glazing}" : ''

    filling + topping
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
  # => "Plain"
puts donut2
  # => "Vanilla"
puts donut3
  # => "Plain with sugar"
puts donut4
  # => "Plain with chocolate sprinkles"
puts donut5
  # => "Custard with icing"