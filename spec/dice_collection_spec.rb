require 'spec_helper'

describe Dicel::DiceCollection do
  its(:dice) { should == [] }
  its(:offset) { should == 0 }
  its(:roll) { should == 0 }

  describe '#add_dice' do
    it 'returns self' do
      subject.add_dice(6).should equal(subject)
    end

    it 'adds a die with the given number of sides and a default multiplier of 1' do
      subject.add_dice(6)
      subject.dice.length.should == 1
      die = subject.dice.first
      die.sides.should == 6
      die.multiplier.should == 1
    end

    it 'takes an optional multiplier' do
      subject.add_dice(6, 10)
      subject.dice.length.should == 1
      die = subject.dice.first
      die.sides.should == 6
      die.multiplier.should == 10
    end

    it 'adding same-sided dice multiple times groups them together' do
      subject.add_dice(6)
      subject.add_dice(6)
      subject.dice.length.should == 1
      die = subject.dice.first
      die.sides.should == 6
      die.multiplier.should == 2
    end

    it 'does not add dice when the multiplier is zero' do
      subject.add_dice(6, 0)
      subject.dice.should == []
    end

    it 'raises an argument error when there is a negative multiplier' do
      expect { subject.add_dice(6, -1) }.to raise_error(ArgumentError)
    end

    it 'raises an error when the number of sides is zero or negative' do
      expect { subject.add_dice(0) }.to raise_error(ArgumentError)
      expect { subject.add_dice(-2) }.to raise_error(ArgumentError)
    end
  end

  describe '#roll' do
    it 'should return the sum of calling #roll on the individual dice plus the offset' do
      subject.offset = 5
      subject.add_dice(2).add_dice(3)
      subject.dice[0].should_receive(:roll).and_return(8)
      subject.dice[1].should_receive(:roll).and_return(1)

      subject.roll.should == 5 + 8 + 1
    end
  end
end