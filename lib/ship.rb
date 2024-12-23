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
    return if sunk?

    @health -= 1
  end
end
