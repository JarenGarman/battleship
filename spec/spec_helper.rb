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


#need two more classes to test the Game class completely
#Player class and a ComputerPlayer class
#Player class for handling the player's moves + ComputerPlayer classfor handling the computer's moves