# Create a cell with a coordinate. Can add a ship and fire upon.
class Cell
  attr_reader :coordinate, :ship, :fired_upon

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    @fired_upon = true
    @ship.hit if @ship
  end

  def fired_upon?
    @fired_upon
  end

  def render(show_ship = false)
    if @fired_upon
      return "X" if @ship && @ship.sunk?
      return "H" if @ship
      "M"
    else
      return "S" if show_ship && @ship
      "."
    end
  end
end
