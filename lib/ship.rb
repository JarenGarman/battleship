class Ship
  attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length # The length of the ship is passed as an argument
    @health = length # Initially, the health of the ship is equal to its length. *kss?
  end

  def hit
    @health -= 1 if @health > 0 # Reduce health by 1 if health is greater than 0
  end

  def sunk?
    @health == 0 # The ship is sunk if its health is 0
  end
end

