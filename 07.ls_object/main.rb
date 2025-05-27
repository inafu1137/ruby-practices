#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'entry_fetcher'
require_relative 'column_list_formatter'
require_relative 'long_list_formatter'

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

entries = EntryFetcher.new(all: options[:all], reverse: options[:reverse]).fetch

if options[:long]
  LongListFormatter.new(entries)
else
  ColumnListFormatter.new(entries)
end.display
