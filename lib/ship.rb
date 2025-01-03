# Create a ship with a name and a length. Ship is sunk once health equals 0.
class Ship
  attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end

  # Decrease health by 1 if health is greater than 0
  def hit
    @health -= 1 if @health > 0
  end

  # Check if the ship is sunk (health is 0 or less)
  def sunk?
    @health <= 0
  end
end
