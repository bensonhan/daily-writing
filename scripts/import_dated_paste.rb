# frozen_string_literal: true

require "date"
require "fileutils"

source_path = ARGV.fetch(0) do
  abort "Usage: ruby scripts/import_dated_paste.rb /path/to/pasted-text.txt"
end

source = File.read(source_path, encoding: "UTF-8")
weekday = "(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)"
pattern = /^(#{weekday})\r?\n(\d{2}\/\d{2}\/\d{4})\r?\n(.*?)(?=^#{weekday}\r?\n\d{2}\/\d{2}\/\d{4}\r?\n|\z)/m
matches = source.scan(pattern)
abort "No dated entries found in #{source_path}" if matches.empty?

writing_dir = File.expand_path("../writing", __dir__)
FileUtils.mkdir_p(writing_dir)
incoming = Hash.new { |hash, month| hash[month] = {} }

matches.each do |written_weekday, source_date, raw_body|
  date = Date.strptime(source_date, "%m/%d/%Y")
  expected_weekday = date.strftime("%A")
  if written_weekday != expected_weekday
    abort "Weekday mismatch for #{source_date}: expected #{expected_weekday}, found #{written_weekday}"
  end

  body = raw_body
    .tr("\u00A0", " ")
    .lines
    .map(&:strip)
    .reject(&:empty?)
    .join("\n\n")

  incoming[date.strftime("%Y-%m")][date.iso8601] = body
end

section_pattern = /^##\s+(\d{4}-\d{2}-\d{2})\s*$\r?\n(.*?)(?=^##\s+\d{4}-\d{2}-\d{2}\s*$|\z)/m

incoming.each do |month, new_entries|
  destination = File.join(writing_dir, "#{month}.md")
  existing = File.exist?(destination) ? File.read(destination, encoding: "UTF-8") : ""
  entries = existing.scan(section_pattern).to_h { |date, body| [date, body.strip] }
  entries.merge!(new_entries)

  month_date = Date.strptime(month, "%Y-%m")
  title = month_date.strftime("# %B %Y")
  sections = entries.sort.map { |date, body| "## #{date}\n\n#{body}" }
  File.write(destination, "#{title}\n\n#{sections.join("\n\n")}\n")
  puts "Updated #{destination}"
end

puts "Imported #{matches.length} entries into #{incoming.length} monthly file(s)."
