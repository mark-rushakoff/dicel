require 'spec_helper'

describe Dicel::DiceCollection do
  its(:dice) { should == [] }
  its(:offset) { should == 0 }
  its(:roll) { should == 0 }
  its(:to_s) { should == '0' }

  describe '#add_dice' do
    it 'returns self' do
      subject.add_dice(6).should equal(subject)
    end

    it 'adds a die with the given number of sides and a default multiplier of 1' do
      subject.add_dice(6)
      subject.dice.should == [Dicel::Die.new(6)]
    end

    it 'takes an optional multiplier' do
      subject.add_dice(6, 10)
      subject.dice.should == [Dicel::Die.new(6, 10)]
    end

    it 'adding same-sided dice multiple times groups them together' do
      subject.add_dice(6)
      subject.add_dice(6)
      subject.dice.should == [Dicel::Die.new(6, 2)]
    end

    it 'does not add dice when the multiplier is zero' do
      subject.add_dice(6, 0)
      subject.dice.should == []
    end

    it 'raises an error when the number of sides is zero or negative' do
      expect { subject.add_dice(0) }.to raise_error(ArgumentError)
      expect { subject.add_dice(-2) }.to raise_error(ArgumentError)
    end
  end

  describe '#add_offset' do
    it 'returns self' do
      subject.add_offset(0).should equal subject
    end

    it 'accepts positive numbers' do
      expect { subject.add_offset(3) }.to change { subject.offset }.by(3)
    end

    it 'accepts negative numbers' do
      expect { subject.add_offset(-3) }.to change { subject.offset }.by(-3)
    end

    it 'accepts zero'do
      expect { subject.add_offset(0) }.not_to change { subject.offset }
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

  describe '#to_s' do
    context 'when there are no dice' do
      it 'shows 0 when the offset is zero' do
        subject.to_s.should == '0'
      end

      it 'shows +<offset> when there is a positive offset' do
        subject.add_offset(1).to_s.should == '1'
      end

      it 'shows -<offset> when there is a negative offset' do
        subject.add_offset(-1).to_s.should == '-1'
      end
    end

    context 'when there are dice and the offset is zero' do
      it 'shows one die as XdY format' do
        subject.add_dice(6).to_s.should == '1d6'
      end

      it 'shows two dice as XdY + XdY format, in ascending order of sides' do
        subject.add_dice(6).add_dice(8, 2).to_s.should == '1d6 + 2d8'
      end
    end

    context 'when there are dice and the offset is non-zero' do
      it 'shows one die as XdY + offset for a positive offset' do
        subject.add_dice(6).add_offset(1).to_s.should == '1d6 + 1'
      end

      it 'shows one die as XdY - offset for a negative offset' do
        subject.add_dice(6).add_dice(8, 2).add_offset(-2).to_s.should == '1d6 + 2d8 - 2'
      end
    end
  end
end