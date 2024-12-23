# Create a cell with a coordinate. Can add a ship and fire upon.
class Cell
  attr_reader :coordinate, :ship

  # (coordinate) is an argument passed to the initialize method - ie "B4"
  def initialize(coordinate)
    @coordinate = coordinate
    @fired_upon = false
  end

  # empty? method checks if a cell is empty
  def empty?
    @ship.nil?
  end

  # place_ship method takes a ship as an argument. it's function is to place a ship in a cell
  def place_ship(ship)
    @ship = ship
  end

  # fired_upon? method checks if a cell has been fired upon
  def fired_upon?
    @fired_upon
  end

  # fire_upon method marks a cell as fired upon
  def fire_upon
    @fired_upon = true
    @ship.hit unless empty? # calls the hit method on the ship if the cell is not empty
  end
end

# fire_upon? & fire_upon are in Cell class because they are methods that are specific to the Cell class.
