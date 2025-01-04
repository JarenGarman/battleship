class Ship
  attr_reader :name, :length, :positions, :hits

  def initialize(name, length)
    @name = name
    @length = length
    @positions = []
    @hits = 0
  end

  def positions=(coordinates)
    @positions = coordinates
  end

  def hit(coordinate)
    @hits += 1 if @positions.include?(coordinate)
  end

  def sunk?
    @hits == @length
  end
end
