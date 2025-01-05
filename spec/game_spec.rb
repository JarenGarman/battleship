require_relative 'spec_helper'

RSpec.describe Game do
  subject(:game) { described_class.new }

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }
  end
end
