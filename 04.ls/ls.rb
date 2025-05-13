#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_COLUMNS = 3

options = {
  all: false,
  reverse: false
}

OptionParser.new do |opts|
  opts.on('-r') do
    options[:reverse] = true
  end
end.parse!

def fetch_entries(show_all:, reverse:)
  entries = Dir.entries('.')
  entries = entries.reject { |entry| entry.start_with?('.') } unless show_all
  entries.sort!
  entries.reverse! if reverse
  entries
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

entries = fetch_entries(show_all: options[:all], reverse: options[:reverse])
format_columns(entries)
