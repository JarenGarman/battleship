require 'simplecov'
SimpleCov.start
require 'pry'
require 'rspec'
require_relative '../lib/ship'
require_relative '../lib/cell'
require_relative '../lib/board'

RSpec.configure(&:disable_monkey_patching!)
