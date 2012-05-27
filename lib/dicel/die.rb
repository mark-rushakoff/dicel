module Dicel
  class Die
    attr_reader :sides, :multiplier

    def initialize(sides, multiplier=1)
      @sides = sides
      raise ArgumentError, 'sides must be greater than 0' if sides <= 0
      @multiplier = multiplier
      raise ArgumentError, 'multiplier must be greater than or equal to 0' if multiplier < 0
    end

    def self.prng
      @prng ||= Random.new
    end

    def roll
      (Dicel::Die.prng.rand(@sides) + 1) * @multiplier
    end
  end
end