# Create a cell with a coordinate. Can add a ship and fire upon.
class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
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
    @ship.hit unless empty?
  end

  def fired_upon?
    @fired_upon
  end

  def render(debug = false)
    if empty?
      return '.' unless fired_upon?

      'M'
    elsif fired_upon?
      return 'H' unless @ship.sunk?

      'X'
    else
      return '.' unless debug

      'S'
    end
  end
end
