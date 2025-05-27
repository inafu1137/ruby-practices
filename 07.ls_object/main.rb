#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'entry_fetcher'
require_relative 'column_formatter'
require_relative 'long_column_formatter'

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
  LongColumnFormatter.new(entries).display
else
  ColumnFormatter.new(entries).display
end
