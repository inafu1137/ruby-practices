#!/usr/bin/env ruby
require "optparse"
require "date"

year = Date.today.year
month = Date.today.month

OptionParser.new do |opts|
  opts.on('-y YEAR', Integer, '年を指定') { |y| year = y }
  opts.on('-m MONTH', Integer, '月を指定') { |m| month = m }
end.parse!

if ARGV.length > 0
  puts "Usage: ./cal.rb [-m MONTH] [-y YEAR]"
  exit 1
end

if month < 1 || month > 12
  puts "月は 1〜12 の間で指定してください"
  exit 1
end

if year < 1970 || year > 2100
  puts "年は1970~2100の範囲で指定してください"
  exit 1
end

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)

puts "#{first_day.strftime("%-m月 %Y")}".center(20)
puts "日 月 火 水 木 金 土"

# 空白部分（1日の曜日に応じて）
print "   " * first_day.wday

(first_day.day..last_day.day).each do |day|
  print day.to_s.rjust(2) + " "
  wday = Date.new(year, month, day).wday
  puts if date.saturday? # 土曜日で改行
end

puts 
