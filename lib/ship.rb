# Create a ship with a name and a length. Ship is sunk once health equals 0.
class Ship
  attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
    #puts "DEBUG: Initializing ship #{name} with length #{length} and health #{@health}"
  end

  def hit
    @health -= 1 if @health > 0
  end

  def sunk?
    @health <= 0
  end
end
