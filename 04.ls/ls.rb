#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMNS = 3

options = {
  long: false
}

OptionParser.new do |opts|
  opts.on('-l') do
    options[:long] = true
  end
end.parse!

def fetch_entries
  Dir.entries('.').reject { |entry| entry.start_with?('.') }.sort
end

def file_mode_string(mode)
  type_flag = case mode & 0o170000
              when 0o040000 then 'd'
              when 0o100000 then '-'
              when 0o120000 then 'l'
              else '?'
              end

  perms = ''
  3.times do |i|
    perms += (mode & (0o400 >> (i * 3))).zero? ? '-' : 'r'
    perms += (mode & (0o200 >> (i * 3))).zero? ? '-' : 'w'
    perms += (mode & (0o100 >> (i * 3))).zero? ? '-' : 'x'
  end

  type_flag + perms
end

def format_long_columns(entries)
  entries.each do |entry|
    path = File.join('.', entry)
    stat = File.lstat(path)

    mode = file_mode_string(stat.mode)
    nlink = stat.nlink
    user = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    size = stat.size
    mtime = stat.mtime.strftime('%b %d %H:%M')
    puts "#{mode} #{nlink} #{user} #{group} #{size.to_s.rjust(6)} #{mtime} #{entry}"
  end
end

def format_columns(entries, columns = MAX_COLUMNS)
  rows = (entries.size.to_f / columns).ceil
  grid = Array.new(rows) { Array.new(columns) }

  entries.each_with_index do |entry, index|
    row = index % rows
    col = index / rows
    grid[row][col] = entry
  end

  col_widths = Array.new(columns, 0)
  columns.times do |col|
    col_entries = grid.map { |row| row[col].to_s }
    col_widths[col] = col_entries.map(&:length).max || 0
  end

  grid.each do |row|
    puts row.each_with_index.map { |item, i|
      item.to_s.ljust(col_widths[i])
    }.join(' ')
  end
end

entries = fetch_entries

if options[:long]
  format_long_columns(entries)
else
  format_columns(entries)
end
