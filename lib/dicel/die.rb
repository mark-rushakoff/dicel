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
      (Dicel::Die.prng.rand(@sides) + 1) * @multiplier
    end

    def ==(other)
      @sides == other.sides && @multiplier == other.multiplier
    end

    def to_s
      "#{multiplier}d#{sides}"
    end
  end
end