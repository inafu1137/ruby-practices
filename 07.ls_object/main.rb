#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'entry_fetcher'
require_relative 'column_formatter'
require_relative 'ls_displayer'

entries = EntryFetcher.new.fetch
formatter = ColumnFormatter.new(entries)
grid = formatter.format
widths = formatter.col_widths(grid)
LsDisplayer.new(grid, widths).display
