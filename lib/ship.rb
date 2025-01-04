class Ship
  attr_reader :name, :length, :positions, :health

  def initialize(name, length)
    @name = name
    @length = length
    @positions = []
    @health = length
  end

  def positions=(coordinates)
    @positions = coordinates
  end

  def hit
    @health -= 1 if @health > 0
  end

  def sunk?
    @health <= 0
  end
end
