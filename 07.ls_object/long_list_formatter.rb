# frozen_string_literal: true

class LongListFormatter
  def initialize(entries)
    @entries = entries
  end

  def format
    total_blocks = calculate_total_blocks
    formatted_entries = @entries.map { |entry| format_entry(entry) }
    [total_blocks, formatted_entries]
  end

  def display
    total_blocks, formatted_entries = format
    puts "合計 #{total_blocks}"
    formatted_entries.each do |row|
      puts row.join(' ')
    end
  end

  private

  def calculate_total_blocks
    @entries.sum { |entry| File.lstat(entry).blocks }
  end

  def format_entry(entry)
    stat = File.lstat(entry)
    [
      file_mode(stat),
      stat.nlink.to_s.rjust(2),
      Etc.getpwuid(stat.uid).name,
      Etc.getgrgid(stat.gid).name,
      stat.size.to_s.rjust(6),
      stat.mtime.strftime('%b %d %H:%M'),
      entry
    ]
  end

  def file_mode(stat)
    type = case stat.ftype
           when 'directory' then 'd'
           when 'file'      then '-'
           when 'link'      then 'l'
           else '?'
           end

    perms = ''
    3.times do |i|
      perms += (stat.mode & (0o400 >> (i * 3))).zero? ? '-' : 'r'
      perms += (stat.mode & (0o200 >> (i * 3))).zero? ? '-' : 'w'
      perms += (stat.mode & (0o100 >> (i * 3))).zero? ? '-' : 'x'
    end

    "#{type}#{perms}"
  end
end
