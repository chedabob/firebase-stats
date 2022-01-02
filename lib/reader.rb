# frozen_string_literal: true

module FirebaseStats
  require 'csv'

  # Parses the Firebase CSV file into sections
  class Reader
    def initialize
      super
      @data = {}
      @mappings = {
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
        'Platform,Users' => :platform,
        'Platform,Users,% Total,User engagement,Total revenue' => :platform_engagement
      }
    end

    def num_sections
      @data.length
    end

    def get(section)
      found = @data[section]
      raise DataError.new(section, search_string(section), tip(section)) if found.nil?
      found
    end

    # @param [String] filename
    def parse_file(filename)
      lines = File.readlines(filename)
      parse(lines)
    end

    # @param [Array<String>] input
    def parse(input)
      @data = {}
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

    # Maps a given CSV header to a section
    # @param [String] header The CSV header line to parse
    # @return [Symbol, nil] The section, or nil if not found
    # rubocop:disable Metrics/MethodLength
    def match_header(header)
      # All of the section headers that can be found in the CSV file, mapping to our internal section symbols

      cleaned_header = header.strip
      section = @mappings[cleaned_header]

      # Kludge for gender_age parsing as the headers aren't always in the right order, so rule out
      # all the other sections first
      section = :gender_age if section.nil? and cleaned_header.include? 'Category,'
      section
    end
    # rubocop:enable Metrics/MethodLength

    # Is this line a comment
    # @param [String] line
    # @return [Boolean]
    def comment?(line)
      line.include?('#')
    end

    def search_string(section)
      @mappings.key(section)
    end

    def tip(section)
      tips = {
        :os_version => "This data can now be found in the Audiences section of Firebase Analytics. Before you export the CSV file, change one of the charts to `Users` by `OS with version`"
      }
      tips[section]
    end
  end
end
