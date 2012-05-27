require 'dicel/die'

module Dicel
  class DiceCollection
    attr_accessor :dice, :offset

    def initialize
      @offset = 0
      @dice = []
    end

    def add_dice(sides, multiplier=1)
      @dice << Dicel::Die.new(sides, multiplier) unless multiplier == 0
    end
  end
end