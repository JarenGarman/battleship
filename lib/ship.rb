# Create a ship with a name and a length. Ship is sunk once health equals 0.
class Ship
  attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end

  def sunk?
    @health.zero?
  end

  def hit
    @health -= 1 unless @health <= 0
  end
end
