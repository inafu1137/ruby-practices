#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = {
  lines: false,
  words: false,
  bytes: false
}

OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:bytes] = true }
end.parse!

if options.values.none?
  options[:lines] = true
  options[:words] = true
  options[:bytes] = true
end

filenames = ARGV.empty? ? [nil] : ARGV

totals = Hash.new(0)

filenames.each do |filename|
  text = filename ? File.read(filename) : $stdin.read
  counts = {}
  counts[:lines] = text.count("\n") if options[:lines]
  counts[:words] = text.split(/\s+/).count { |word| !word.empty? } if options[:words]
  counts[:bytes] = text.bytesize if options[:bytes]

  counts.each { |k, v| totals[k] += v }

  output = []
  output << counts[:lines].to_s.rjust(8) if options[:lines]
  output << counts[:words].to_s.rjust(8) if options[:words]
  output << counts[:bytes].to_s.rjust(8) if options[:bytes]
  output << filename if filename
  puts output.join(' ')
end

if filenames.size > 1
  output = []
  output << totals[:lines].to_s.rjust(8) if options[:lines]
  output << totals[:words].to_s.rjust(8) if options[:words]
  output << totals[:bytes].to_s.rjust(8) if options[:bytes]
  output << 'total'
  puts output.join(' ')
end
