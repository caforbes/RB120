class Polygon
  SIDES = '?'

  attr_reader :num_sides

  def initialize
    @num_sides = SIDES
  end
end

class Triangle < Polygon
  SIDES = 3
end

triangle = Triangle.new
puts triangle.num_sides
