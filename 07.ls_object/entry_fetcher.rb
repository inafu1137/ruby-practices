# frozen_string_literal: true

class EntryFetcher
  def initialize(path = '.')
    @path = path
  end

  def fetch
    Dir.children(@path).reject { |entry| entry.start_with?('.') }.sort
  end
end
