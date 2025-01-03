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
      puts "DEBUG: Ship #{@ship.name} hit. Health: #{@ship.health}"  # Debugging output
      return @ship.sunk? ? :sunk : :hit
    else
      return :miss
    end
  end

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
