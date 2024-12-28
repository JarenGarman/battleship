require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
end
require 'pry'
require 'rspec'
require_relative '../lib/ship'
require_relative '../lib/cell'
require_relative '../lib/board'
require_relative '../lib/game'
# require_relative '../lib/player'
# require_relative '../lib/computer_player'

RSpec.configure(&:disable_monkey_patching!)


# #we'll need two more classess to test the Game class completely
# #we'll need a Player class and a ComputerPlayer class
# #the Player class will be responsible for handling the player's moves and the ComputerPlayer class will be responsible for handling the computer's moves
# #we'll need to create a new instance of the Player class and ComputerPlayer class in the Game