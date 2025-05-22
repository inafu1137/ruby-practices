#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'entry_fetcher'
require_relative 'column_formatter'
require_relative 'ls_displayer'

options = {
  all: false,
  reverse: false,
  long: false
}

OptionParser.new do |opts|
  opts.on('-a') { options[:all] = true }
  opts.on('-r') { options[:reverse] = true }
  opts.on('-l') { options[:long] = true }
end.parse!

fetcher = EntryFetcher.new(all: options[:all], reverse: options[:reverse])
entries = fetcher.fetch

if options[:long]
  total_blocks = entries.sum { |entry| File.lstat(entry).blocks }
  puts "合計 #{total_blocks}"

  entries.each do |entry|
    stat = File.lstat(entry)
    mode = case stat.ftype
           when 'directory' then 'd'
           when 'file'      then '-'
           when 'link'      then 'l'
           else '?'
           end

    perms = ''
    3.times do |i|
      perms += (stat.mode & (0o400 >> (i * 3))).zero? ? '-' : 'r'
      perms += (stat.mode & (0o200 >> (i * 3))).zero? ? '-' : 'w'
      perms += (stat.mode & (0o100 >> (i * 3))).zero? ? '-' : 'x'
    end

    nlink = stat.nlink
    user = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    size = stat.size
    mtime = stat.mtime.strftime('%b %d %H:%M')
    puts "#{mode}#{perms} #{nlink} #{user} #{group} #{size.to_s.rjust(6)} #{mtime} #{entry}"
  end
else
  formatter = ColumnFormatter.new(entries)
  grid = formatter.format
  widths = formatter.col_widths(grid)
  LsDisplayer.new(grid, widths).display
end
