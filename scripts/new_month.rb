# frozen_string_literal: true

require "date"
require "fileutils"

month = ARGV.fetch(0) { abort "Usage: ruby scripts/new_month.rb YYYY-MM" }
date = Date.strptime(month, "%Y-%m")
abort "Use an exact YYYY-MM value" unless date.strftime("%Y-%m") == month

writing_dir = File.expand_path("../writing", __dir__)
destination = File.join(writing_dir, "#{month}.md")
abort "Already exists: #{destination}" if File.exist?(destination)

FileUtils.mkdir_p(writing_dir)
File.write(destination, "#{date.strftime("# %B %Y")}\n\n")
puts "Created #{destination}"
