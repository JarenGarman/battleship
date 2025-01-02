# Create a cell with a coordinate. Can add a ship and fire upon.
class Cell
  attr_reader :coordinate, :ship, :fired_upon

  # (coordinate) is an argument passed to the initialize method - ie "B4"
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
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

  # fire_upon method marks a cell as fired upon and returns the result
  def fire_upon
    return :already_fired if @fired_upon

    @fired_upon = true
    if @ship
      @ship.hit
      return :sunk if @ship.sunk?
      :hit
    else
      :miss
    end
  end

  # fired_upon? method checks if a cell has been fired upon
  def fired_upon?
    @fired_upon
  end

  def render(show_ship = false)
    if fired_upon?
      if empty?
        "M"
      else
        @ship.sunk? ? "X" : "H"
      end
    else
      show_ship && !empty? ? "S" : "."
    end
  end
end
