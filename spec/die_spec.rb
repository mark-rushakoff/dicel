require 'spec_helper'

describe 'Dicel::Die' do
  subject { Dicel::Die.new(6) }
  its(:sides) { should == 6 }

  it 'raises an exception for sides <= 0' do
    expect { Dicel::Die.new(0) }.to raise_error(ArgumentError)
    expect { Dicel::Die.new(-5) }.to raise_error(ArgumentError)
  end

  it 'raises an exception for multiplier < 0' do
    expect { Dicel::Die.new(3, 0) }.not_to raise_error(ArgumentError)
    expect { Dicel::Die.new(3, -1) }.to raise_error(ArgumentError)
  end

  describe 'multiplier argument' do
    it 'is stored' do
      Dicel::Die.new(6, 3).multiplier.should == 3
    end
  end

  describe '#roll' do
    def stub_roll(expected_sides, return_val)
      fake_prng = double()
      fake_prng.should_receive(:rand).with(expected_sides).and_return(return_val - 1)
      fake_prng
      Dicel::Die.stub(:prng).and_return(fake_prng)
    end

    it 'returns a number between 1 and the number of sides' do
      stub_roll(6, 5)
      subject.roll.should == 5
    end

    it 'applies the multiplier' do
      stub_roll(6, 4)
      Dicel::Die.new(6, 3).roll.should == 12
    end
  end
end
