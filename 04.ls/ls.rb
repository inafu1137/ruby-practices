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

  grid.each do |row|
    puts row.map { |item| item.to_s.ljust(20) }.join
  end
end

entries = fetch_entries
format_columns(entries)
