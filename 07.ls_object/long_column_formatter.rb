# frozen_string_literal: true

class LongColumnFormatter
  def initialize(entries)
    @entries = entries
  end

  def format
    total_blocks = @entries.sum { |entry| File.lstat(entry).blocks }
    formatted_entries = @entries.map do |entry|
      stat = File.lstat(entry)
      mode = case stat.ftype
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

      [
        "#{mode}#{perms}",
        stat.nlink.to_s.rjust(2),
        Etc.getpwuid(stat.uid).name,
        Etc.getgrgid(stat.gid).name,
        stat.size.to_s.rjust(6),
        stat.mtime.strftime('%b %d %H:%M'),
        entry
      ]
    end

    [["合計 #{total_blocks}"], *formatted_entries]
  end
end
