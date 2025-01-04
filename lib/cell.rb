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
      return "X" if @ship&.sunk? # Render as 'X' if the ship is sunk.
      return "H" if @ship        # Render as 'H' if the shot hit a ship but it's not sunk.
      "M"                        # Render as 'M' if it was a miss.
    else
      return "S" if show_ship && @ship
      "."
    end
  end
end
