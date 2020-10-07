class Transform
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def uppercase
    content.upcase
  end

  def self.lowercase(str)
    str.downcase
  end
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')