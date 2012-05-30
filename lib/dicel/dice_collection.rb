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

    def add_offset(offset)
      @offset += offset
      self
    end

    def roll
      @dice.map(&:roll).inject(offset, &:+)
    end

    def +(other)
      sum = DiceCollection.new
      [self, other].each do |collectionish|
        if collectionish.respond_to? :dice
          collectionish.dice.each do |die|
            sum.add_dice(die.sides, die.multiplier)
          end
        end
        sum.add_offset(collectionish.respond_to?(:offset) ? collectionish.offset : collectionish)
      end

      sum
    end

    def to_s
      dice = @dice.reject { |die| die.multiplier == 0 }.sort_by { |die| die.sides }
      if dice.empty?
        offset.to_s
      else
        on_first = true
        dice.map { |die|
          text = format_die(die)
          if on_first
            on_first = false
            text.gsub!(/^.../, '')
          end

          text
        }.join('') + offset_to_s
      end
    end

    private
    def format_die(die)
      die.to_s.gsub(/^(-)/, ' - ').gsub(/(?:^)(\d)/, ' + \1')
    end

    def offset_to_s
      if @offset == 0
        ''
      elsif @offset < 0
        " - #{-offset}"
      else
        " + #{offset}"
      end
    end
  end
end
