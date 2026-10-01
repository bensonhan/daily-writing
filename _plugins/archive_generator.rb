# frozen_string_literal: true

require "date"

module DailyWriting
  class EntryPage < Jekyll::PageWithoutAFile
    def initialize(site, date, body)
      dir = date.strftime("%Y/%m/%d")
      body_parts = body.split(/\r?\n\s*\r?\n/, 2)
      first_paragraph = body_parts.first.strip
      preview_words = first_paragraph.split(/\s+/)
      has_more = preview_words.length > 80 || body_parts.drop(1).any? { |part| !part.strip.empty? }
      preview = if has_more
        visible_word_count = [preview_words.length, 80].min
        visible_word_count -= 1 if visible_word_count > 1
        "#{preview_words.first(visible_word_count).join(" ")}…"
      else
        first_paragraph
      end

      super(site, site.source, dir, "index.md")

      self.content = body
      self.data = {
        "layout" => "entry",
        "date" => date,
        "excerpt" => preview,
        "permalink" => "/#{dir}/",
        "archive_url" => date.strftime("/%Y/%m/")
      }
    end
  end

  class ArchivePage < Jekyll::PageWithoutAFile
    def initialize(site, year, month, entries)
      dir = format("%04d/%02d", year, month)
      super(site, site.source, dir, "index.html")

      self.data = {
        "layout" => "feed",
        "year" => year,
        "month" => month,
        "entries" => entries,
        "archive_url" => "/#{dir}/",
        "eyebrow" => Date.new(year, month, 1).strftime("%B %Y")
      }
    end
  end

  class ArchiveGenerator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      entries = load_entries(site)
      site.pages.concat(entries)

      entries.sort_by! { |entry| entry.data.fetch("date") }.reverse!

      grouped = entries.group_by { |entry| entry.data.fetch("date").strftime("%Y-%m") }
      latest_month = entries.first.data.fetch("date")
      latest_month_key = latest_month.strftime("%Y-%m")
      site.config["latest_month_entries"] = grouped.fetch(latest_month_key)
      site.config["latest_month_label"] = latest_month.strftime("%B %Y")

      grouped.each do |key, month_entries|
        year, month = key.split("-").map(&:to_i)
        site.pages << ArchivePage.new(site, year, month, month_entries)
      end

      years = grouped.keys.group_by { |key| key[0, 4].to_i }.sort.reverse.to_h
      site.config["latest_year"] = years.keys.first
      site.config["archive_tree"] = years.map do |year, keys|
        {
          "year" => year,
          "months" => keys.sort.reverse.map do |key|
            month = key[5, 2].to_i
            {
              "name" => Date.new(year, month, 1).strftime("%B"),
              "url" => format("/%04d/%02d/", year, month)
            }
          end
        }
      end
    end

    private

    def load_entries(site)
      seen_dates = {}
      pattern = /^##\s+(\d{4}-\d{2}-\d{2})\s*$\r?\n(.*?)(?=^##\s+\d{4}-\d{2}-\d{2}\s*$|\z)/m

      Dir[site.in_source_dir("writing", "*.md")].sort.flat_map do |path|
        source_month = File.basename(path, ".md")
        unless source_month.match?(/\A\d{4}-\d{2}\z/)
          Jekyll.logger.abort_with "Monthly writing filenames must use YYYY-MM.md:", path
        end

        matches = File.read(path, encoding: "UTF-8").scan(pattern)
        Jekyll.logger.warn "Daily writing:", "No dated entries found in #{path}" if matches.empty?

        matches.map do |date_string, body|
          date = Date.iso8601(date_string)
          unless date.strftime("%Y-%m") == source_month
            Jekyll.logger.abort_with "Entry #{date_string} is in the wrong monthly file:", path
          end
          if seen_dates.key?(date_string)
            Jekyll.logger.abort_with "Duplicate entry date #{date_string} in:", path
          end

          seen_dates[date_string] = true
          EntryPage.new(site, date, body.strip)
        rescue Date::Error
          Jekyll.logger.abort_with "Invalid entry date #{date_string} in:", path
        end
      end
    end
  end
end
