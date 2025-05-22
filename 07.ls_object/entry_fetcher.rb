# frozen_string_literal: true

class EntryFetcher
  def initialize(path = '.', all: false, reverse: false)
    @path = path
    @all = all
    @reverse = reverse
  end

  def fetch
    entries = Dir.entries(@path)
    entries.reject! { |entry| entry.start_with?('.') } unless @all
    entries.sort!
    entries.reverse! if @reverse
    entries
  end
end
