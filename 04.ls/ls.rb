#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_COLUMNS = 3

def fetch_entries
  Dir.children('.').sort
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
format_columns(entries)
