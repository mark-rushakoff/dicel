module Dicel
  class Die
    attr_reader :sides, :multiplier

    def initialize(sides, multiplier=1)
      raise ArgumentError, 'sides must be greater than 0' if sides <= 0
      @sides = sides
      @multiplier = multiplier
    end

    def self.prng
      @prng ||= Random.new
    end

    def roll
      sum = 0
      multiplier.times do
        sum += (::Dicel::Die.prng.rand(@sides) + 1)
      end
      sum
    end

    def dice
      [self]
    end

    def offset
      0
    end

    def ==(other)
      @sides == other.sides && @multiplier == other.multiplier
    end

    def +(other)
      to_dice_collection + other
    end

    def to_s
      "#{multiplier}d#{sides}"
    end

    private
    def to_dice_collection
      (::Dicel::DiceCollection.new.add_dice(sides, multiplier))
    end
  end
end
