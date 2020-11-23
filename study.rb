module Mailable
  attr_accessor :mailing_address
end

class Building
end

class Library < Building
  include Mailable
end

lib = Library.new
p lib.class.ancestors

p Module.ancestors
