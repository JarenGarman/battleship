require 'spec_helper'

#tried to run wih spec_helper but it was not working - hard coded in

RSpec.describe Cell do
  it 'exists' do
    cell = Cell.new("B4")
    expect(cell).to be_instance_of(Cell)
  end

  it 'has a coordinate' do
    cell = Cell.new("B4")
    expect(cell.coordinate).to eq("B4")
  end

  it 'is empty by default' do
    cell = Cell.new("B4")
    expect(cell.ship).to be_nil
    expect(cell.empty?).to be true
  end

  it 'can place a ship' do
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser) #place_ship method is called on the cell object and the cruiser object is passed as an argument
    expect(cell.ship).to eq(cruiser) #expect the ship attribute of the cell object to be equal to the cruiser object
    expect(cell.empty?).to be false #expect the empty? method to return false
  end
end