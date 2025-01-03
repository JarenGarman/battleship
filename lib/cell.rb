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
    return :already_fired if @fired_upon

    @fired_upon = true
    if @ship
      @ship.hit
      return @ship.sunk? ? :sunk : :hit
    else
      return :miss
    end
  end

  def fired_upon?
    @fired_upon
  end

  def render(reveal = false)
    if @fired_upon
      return "X" if @ship&.sunk? # Mark as sunk
      return "H" if @ship        # Mark as hit
      return "M"                 # Mark as miss
    elsif reveal && @ship
      "S" # Reveal ship if flag is true
    else
      "."
    end
  end
end
