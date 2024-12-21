require 'simplecov'
SimpleCov.start
require 'pry'
require 'rspec'
require_relative '../lib/ship'

RSpec.configure(&:disable_monkey_patching!)
