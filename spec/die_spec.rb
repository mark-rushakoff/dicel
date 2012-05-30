require 'spec_helper'

describe 'Dicel::Die' do
  subject { Dicel::Die.new(6) }
  its(:sides) { should == 6 }
  its(:to_s) { should == '1d6' }
  its(:offset) { should == 0 }

  it 'shows a negative multiplier in to_s' do
    Dicel::Die.new(6, -2).to_s.should == '-2d6'
  end

  it 'should compare sides and multiplier for == operator' do
    Dicel::Die.new(6).should == Dicel::Die.new(6)
    Dicel::Die.new(6).should_not == Dicel::Die.new(7)
    Dicel::Die.new(6, 2).should == Dicel::Die.new(6, 2)
    Dicel::Die.new(6, 2).should_not == Dicel::Die.new(6, 3)
  end

  it 'raises an exception for sides <= 0' do
    expect { Dicel::Die.new(0) }.to raise_error(ArgumentError)
    expect { Dicel::Die.new(-5) }.to raise_error(ArgumentError)
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

  describe '#dice' do
    it 'yields itself in an array' do
      Dicel::Die.new(6, 3).dice.should == [Dicel::Die.new(6,3)]
    end
  end

  describe '#+' do
    it 'accepts another die object' do
      (Dicel::Die.new(6, 3) + Dicel::Die.new(4, 2)).to_s.should == '2d4 + 3d6'
    end

    it 'accepts a number for offset' do
      (Dicel::Die.new(6, 3) + 1).to_s.should == '3d6 + 1'
    end
  end
end
