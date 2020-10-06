class Person
  def name=(names)
    names = names.split

    @last_name = names.pop
    @first_name = names.join(' ')
  end

  def name
    "#{@first_name} #{@last_name}"
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
