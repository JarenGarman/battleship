require 'simplecov'
SimpleCov.start
require 'pry'
require 'rspec'
require_relative '../lib/ship'
require_relative '../lib/cell'

RSpec.configure(&:disable_monkey_patching!)
