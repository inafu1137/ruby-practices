# frozen_string_literal: true

class LsDisplayer
  def initialize(grid, col_widths)
    @grid = grid
    @col_widths = col_widths
  end

  def display
    @grid.each do |row|
      puts row.each_with_index.map { |item, i|
        item.to_s.ljust(@col_widths[i])
      }.join(' ')
    end
  end
end
