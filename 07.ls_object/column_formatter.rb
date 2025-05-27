# frozen_string_literal: true

class ColumnFormatter
  def initialize(entries, columns = 3)
    @entries = entries
    @columns = columns
  end

  def format
    rows = (@entries.size.to_f / @columns).ceil
    grid = Array.new(rows) { Array.new(@columns) }
    @entries.each_with_index do |entry, index|
      row = index % rows
      col = index / rows
      grid[row][col] = entry
    end
    grid
  end

  def col_widths(grid)
    Array.new(@columns, 0).tap do |widths|
      @columns.times do |col|
        col_entries = grid.map { |row| row[col].to_s }
        widths[col] = col_entries.map(&:length).max || 0
      end
    end
  end

  def display
    grid = format
    widths = col_widths(grid)
    grid.each do |row|
      puts row.each_with_index.map { |item, i|
        item.to_s.ljust(widths[i])
      }.join(' ')
    end
  end
end
