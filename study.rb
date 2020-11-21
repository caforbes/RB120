# module Swims
#   SWIMS_IN = "H20"

#   def enable_swimming
#     @can_swim = true
#   end

#   def swim
#     puts "blub blub"
#   end
# end

# class Penguin
#   include Swims

#   def initialize
#     add_swimmer
#   end
# end

# plucky = Penguin.new
# puts Swims.num_swimmers
# puts Swims::SWIMS_IN

module Roman
  ALPHABET = ('A'..'Z').to_a

  def self.numeral_convert(roman)
    12  # code to make roman-arabic numeral convert
  end
end

puts Roman.numeral_convert('XII')
