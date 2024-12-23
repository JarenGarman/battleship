class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate) #(coordinate) is an argument passed to the initialize method - ie "B4"
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false 
  end

  def empty? #empty? method checks if a cell is empty
    @ship.nil?
  end

  def place_ship(ship) #place_ship method takes a ship as an argument. it's function is to place a ship in a cell
    @ship = ship
  end

  def fired_upon? #fired_upon? method checks if a cell has been fired upon
    @fired_upon
  end

  def fire_upon #fire_upon method marks a cell as fired upon
    @fired_upon = true
    @ship.hit unless empty? #calls the hit method on the ship if the cell is not empty
  end
end

#fire_upon? & fire_upon are in Cell class because they are methods that are specific to the Cell class. 
