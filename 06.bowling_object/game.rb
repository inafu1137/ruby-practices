# frozen_string_literal: true

require_relative './shot'
require_relative './frame'

class Game
  def initialize(score_string)
    shots = score_string.split(',').map { |mark| Shot.new(mark) }
    @frames = []
    build_frames(shots)
  end

  def score
    point = 0
    @frames.each_with_index do |frame, index|
      point += frame.total_score

      next if index >= 9

      if frame.strike?
        point += next_two_shots_score(index)
      elsif frame.spare?
        point += next_shot(index)
      end
    end
    point
  end

  private

  def build_frames(shots)
    i = 0

    10.times do |frame_index|
      frame = Frame.new

      frame.add_shot(shots[i])
      i += 1

      if !frame.strike? || frame_index == 9
        frame.add_shot(shots[i])
        i += 1
      end

      # 10フレーム目の3投目
      frame.add_shot(shots[i]) if frame_index == 9 && frame.total_score >= 10

      @frames << frame
    end
  end

  def next_shot(index)
    @frames[index + 1]&.first_score || 0
  end

  def next_two_shots_score(index)
    next_frame = @frames[index + 1]
    return 0 unless next_frame

    if next_frame.strike? && index + 2 < @frames.size
      next_frame.first_score + @frames[index + 2].first_score
    else
      next_frame.first_score + next_frame.second_score
    end
  end
end
