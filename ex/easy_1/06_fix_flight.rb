class Flight
  # attr_reader :database_handle  # => don't use this at all (esp publicly)

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end
