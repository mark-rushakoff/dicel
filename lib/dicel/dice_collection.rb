require 'dicel/die'

module Dicel
  class DiceCollection
    attr_accessor :dice, :offset

    def initialize
      @offset = 0
      @dice = []
    end

    def add_dice(sides, multiplier=1)
      return if multiplier == 0
      index = @dice.find_index { |die| die.sides == sides }
      if index
        die = @dice[index]
        @dice[index] = Dicel::Die.new(sides, die.multiplier + multiplier)
      else
        @dice << Dicel::Die.new(sides, multiplier)
      end
      self
    end

    def roll
      @dice.map(&:roll).inject(offset, &:+)
    end
  end
end