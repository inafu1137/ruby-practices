# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(mark)
    @score = mark == 'X' ? 10 : mark.to_i
  end

  def strike?
    score == 10
  end
end
