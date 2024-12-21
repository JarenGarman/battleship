class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate) #(coordinate) is an argument passed to the initialize method - ie "B4"
    @coordinate = coordinate
    @ship = nil #ship is an instance variable and is set to nil
  end

  def empty? 
    @ship.nil?
  end

  def place_ship(ship) #place_ship method takes a ship as an argument. it's function is to place a ship in a cell
    @ship = ship
  end
end