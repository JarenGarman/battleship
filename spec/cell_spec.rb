require 'spec_helper'

RSpec.describe Cell do
  it 'exists' do #Cell class exists and is an instance of Cell
    cell = Cell.new("B4")
    expect(cell).to be_instance_of(Cell) 
  end

  it 'has a coordinate' do #coordinate is an argument passed to the initialize method - ie "B4"
    cell = Cell.new("B4")
    expect(cell.coordinate).to eq("B4")
  end

  it 'is empty by default' do #empty? method checks if a cell is empty
    cell = Cell.new("B4")
    expect(cell.ship).to be_nil
    expect(cell.empty?).to be true
  end

  it 'can place a ship' do
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser) #place_ship method is called on the cell object and the cruiser object is passed as an argument
    expect(cell.ship).to eq(cruiser) 
    expect(cell.empty?).to be false 
  end

  it 'is not fired upon by default' do #fired_upon? method returns false by default
    cell = Cell.new("B4")
    expect(cell.fired_upon?).to be false
  end

  it 'can be fired upon' do #fire_upon method marks a cell as fired upon
    cell = Cell.new("B4")
    cell.fire_upon
    expect(cell.fired_upon?).to be true
  end

  it 'reduces the health of the ship when fired upon' do #fire_upon method calls the hit method on the ship if the cell is not empty
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)
    cell.fire_upon
    expect(cruiser.health).to eq(2)
  end
end