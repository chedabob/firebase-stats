# frozen_string_literal: true

class FirebaseStats
  require 'csv'

  # Parses the Firebase CSV file into sections
  class Reader
    attr_reader :data

    def initialize
      super
      @data = {}
    end

    # @param [String] filename
    def parse_file(filename)
      lines = File.readlines(filename)
      parse(lines)
    end

    # @param [Array<String>] input
    def parse(input)
      curr_lines = []
      input.each_with_index do |line, idx|
        curr_lines.push(line) unless comment?(line) || line.strip.empty?

        if (idx == input.length - 1) || line.strip.empty?
          process_lines curr_lines unless curr_lines.empty?
          curr_lines = []
        end
      end
    end

    private

    # @param [Array<String>] lines
    def process_lines(lines)
      section = match_header lines[0]
      return if section.nil?

      parsed = CSV.parse(lines.join, headers: true)
      @data[section] = parsed if @data[section].nil?
    end

    # @param [String] header
    # @return [Symbol, nil]
    # rubocop:disable Metrics/MethodLength
    def match_header(header)
      mappings = {
        'Day,28-Day,7-Day,1-Day' => :active_users,
        'Day,Average engagement time' => :daily_engagement,
        'Page path and screen class,User engagement,Screen views' => :screens,
        'Day,Total revenue' => :revenue,
        'App,Crash-free users' => :crash_free_users,
        'App,Version,Status' => :version_adoption,
        'Source,first_open conversions,LTV' => :acquisition,
        'Date,Week 0,Week 1,Week 2,Week 3,Week 4,Week 5' => :retention_cohorts,
        'Country ID,Sessions,% Total' => :audience_country,
        'Device model,Users' => :devices,
        'OS with version,Users' => :os_version,
        'Gender,Users' => :gender,
        'Category,Female,Male' => :gender_age,
        'Platform,Users' => :platform,
        'Platform,Users,% Total,User engagement,Total revenue' => :platform_engagement
      }

      mappings[header.strip]
    end
    # rubocop:enable Metrics/MethodLength

    # @param [String] line
    def comment?(line)
      line.include?('#')
    end
  end
end
