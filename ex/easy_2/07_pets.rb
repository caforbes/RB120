class Pet
  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{@animal} named #{@name}"
  end
end

class Owner
  attr_reader :name, :pet_list

  def initialize(name)
    @name = name
    @pet_list = []
  end

  def number_of_pets
    pet_list.length
  end
end

class Shelter
  def initialize
    @list_of_adopters = []
    @unadopted_pets = []
  end

  def to_s
    "The Animal House"
  end

  def intake(*pets)
    pets.each { |pet| @unadopted_pets << pet }
  end

  def adopt(owner, pet)
    owner.pet_list << pet
    @list_of_adopters << owner unless @list_of_adopters.include?(owner)
  end

  def print_adoptions
    @list_of_adopters.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      puts owner.pet_list
      puts "\n"
    end
  end

  def number_of_pets
    @unadopted_pets.length
  end

  def print_unadopted
    puts "#{self} has the following unadopted pets:"
    puts @unadopted_pets
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new

shelter.intake Pet.new('dog', 'Asta'), Pet.new('dog', 'Laddie'),
Pet.new('cat', 'Fluffy'), Pet.new('cat', 'Kat'), Pet.new('cat', 'Ben'),
Pet.new('parakeet', 'Chatterbox'), Pet.new('parakeet', 'Bluebell')

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_adoptions

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{shelter} has #{shelter.number_of_pets} unadopted pets."

shelter.print_unadopted