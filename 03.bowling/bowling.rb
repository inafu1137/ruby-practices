#!/usr/bin/env ruby

# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.map { |s| s == 'X' ? 10 : s.to_i }

frames = []
i = 0

while frames.size < 10
  ## ストライク時の処理
  if shots[i] == 10 && frames.size < 9
    frames << [10]
    i += 1
  else
    ## それ以外の処理
    frames << [shots[i], shots[i + 1]]
    i += 2
  end
end

## 10フレーム目の3投目を投げるかどうかの判定
frames[9] << shots[i] if frames[9].sum >= 10 && frames[9].size == 2

## スコアの計算
point = 0

frames.each_with_index do |frame, frame_index|
  sum = frame.sum

  # 最終フレーム（10フレーム目）はそのまま合計
  if frame_index == 9
    point += sum
    next
  end

  # ストライク処理
  if frame[0] == 10
    next_frame = frames[frame_index + 1]
    bonus = if next_frame[0] == 10 && frames[frame_index + 2]
              frames[frame_index + 2][0]
            else
              next_frame[1] || 0
            end

    point += 10 + next_frame[0] + bonus
    next
  end

  # スペア処理
  if sum == 10
    point += 10 + frames[frame_index + 1][0]
    next
  end

  # 通常フレーム
  point += frame.sum
end

puts point
