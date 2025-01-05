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
require_relative '../lib/computer'
require_relative '../lib/player'

RSpec.configure(&:disable_monkey_patching!)
