class MyClass
  attr_accessor :variable

  def set_var1
    variable = 1
  end

  def set_var2
    self.variable = 1
  end
end

obj = MyClass.new
obj.set_var1
puts obj.variable # => nil
obj.set_var2
puts obj.variable # => 1
