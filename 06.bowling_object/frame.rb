# frozen_string_literal: true

class Frame
  attr_reader :score

  def initialize(*shots)
    @shots = shots
  end

  def strike?
    @shots.first&.strike?
  end

  def spare?
    !strike? && @shots.size >= 2 && total_score == 10
  end

  def total_score
    @shots.map(&:score).sum
  end

  def first_score
    @shots[0]&.score || 0
  end

  def second_score
    @shots[1]&.score || 0
  end
end
