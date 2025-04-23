#!/usr/bin/env ruby

# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)
end

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
frames.each_with_index do |frame, index|
  if frame[0] == 10 && index < 9 ## ストライク
    next_frame = frames[index + 1]
    if next_frame[0] == 10 && index < 8
      next_next_frame = frames[index + 2]
      point += 10 + 10 + next_next_frame[0]
    else
      point += 10 + next_frame[0] + next_frame[1]
    end
  elsif frame.sum == 10 && frame.size == 2 && index < 9 ## スペア
    point += 10 + frames[index + 1][0]
  else ## その他
    point += frame.sum
  end
end

puts point
