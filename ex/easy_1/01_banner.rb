class Banner
  def initialize(message, width = message.length)
    @message = message

    min_length = @message.split.map(&:length).max
    @spacing =  case
                when width > 76 then 76
                when min_length && width < min_length then min_length
                else width
                end
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{'-'*@spacing}-+"
  end

  def empty_line
    "| #{' '*@spacing} |"
  end

  def message_line
    lines = wrapped_message
    lines.map { |line| "| #{line.center(@spacing)} |" }
  end

  def wrapped_message
    return [@message] unless @message.length > @spacing

    words = @message.split
    lines = ['']

    words.each do |word|
      if lines.last.length + word.length + 1 > @spacing
        lines << word
      else
        lines.last.concat(' ', word)
      end
    end
    lines
  end
end

puts Banner.new('To boldly go where no one has gone before.')
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+
puts Banner.new('')
# +--+
# |  |
# |  |
# |  |
# +--+

puts Banner.new('To boldly go where no one has gone before.', 60)
puts Banner.new('To boldly go where no one has gone before.', 20)
puts Banner.new('To boldly go where no one has gone before.', 0)
