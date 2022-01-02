# frozen_string_literal: true

module FirebaseStats
  require 'csv'
  require 'android/devices'
  require 'open-uri'

  # Transforms the parsed Firebase file into something more user friendly
  class Wrapper
    # @param [FirebaseStats::Reader] stats
    def initialize(stats)
      super()
      @stats = stats
    end

    # Get all OS versions, grouped by Major version
    # @param [Symbol] platform One of :all, :ios, :android
    # @param [Boolean] grouped Group by Major OS version
    # @param [Boolean] major_order Order by Major OS version (instead of percentage)
    def os(platform: :all, grouped: true, major_order: true)
      os_data = all_os
      filtered = filter_os(os_data, platform)

      data = if grouped
               make_group_stats(filtered, platform)
             else
               filtered
             end

      major_order ? major_version_sort(data) : data
    end

    # Gets all devices
    # @param [Boolean] friendly Transform the Android model numbers into their human numaes
    # @param [Integer] limit Number of devices to turn
    # @param [Symbol] platform One of :all, :ios, :android
    def devices(friendly: false, limit: 10, platform: :all)
      filtered = DeviceUtils.filter_device(@stats.get(:devices), platform)
      filtered = filtered.take(limit || 10)
      cleaned = []
      filtered.each do |row|
        device = {
          'model' => row['Device model']
        }
        if friendly && ((platform == :all) || (platform == :android))
          mapped = Android::Devices.search_by_model(row['Device model'])
          device['friendly'] = if mapped.nil?
                                 row['Device model']
                               else
                                 mapped.name
                               end
        end
        device['count'] = row['Users'].to_i

        cleaned << device
      end
      cleaned
    end

    def gender
      raw = @stats.get(:gender)
      data = []
      raw.each do |row|
        data << {
          'gender' => row['Gender'],
          'count' => row['Users'].to_i
        }
      end
      data
    end

    def gender_age
      raw = @stats.get(:gender_age)
      data = []
      raw.each do |row|
        data << {
          'age' => row['Category'],
          'male' => (row['Male'].to_f * 100).round(2),
          'female' => (row['Female'].to_f * 100).round(2),
          'other' => (row['Other'].to_f * 100).round(2)
        }
      end
      data
    end

    private

    # @param [CSV::Table] os_data
    # @param [Symbol] platform One of :all, :ios, :android
    def filter_os(os_data, platform)
      case platform
      when :android
        os_data.select { |row| row['version'].downcase.include?('android') }
      when :ios
        os_data.select { |row| row['version'].downcase.include?('ios') }
      else
        os_data
      end
    end

    def as_percentage(total, value)
      percentage = (value / total) * 100
      if percentage < 0.01
        percentage.round(4)
      else
        percentage.round(2)
      end
    end

    def ios_os_group(os_details)
      filter_os(os_details, :ios).group_by { |row| row['version'].match('(iOS [0-9]{1,2})').captures[0] }
    end

    def android_os_group(os_details)
      filter_os(os_details, :android).group_by { |row| row['version'].match('(Android [0-9]{1,2})').captures[0] }
    end

    # Get all OS versions
    def all_os
      data = @stats.get(:os_version)

      data.map do |row|
        {
          'version' => row['OS with version'],
          'count' => row['Users'].to_i
        }
      end
    end

    def make_group_stats(os_data, platform)
      data = make_os_groups(os_data, platform)

      total_devices = os_total(os_data)
      data.map do |k, v|
        version_name = k
        group_total = v.map { |version| version['count'].to_i }.reduce(0, :+)
        { 'version' => version_name,
          'total' => group_total,
          'percentage' => as_percentage(total_devices.to_f, group_total) }
      end
    end

    def make_os_groups(os_data, platform)
      case platform
      when :ios
        ios_os_group(os_data)
      when :android
        android_os_group(os_data)
      else
        android_os_group(os_data).merge ios_os_group(os_data)
      end
    end

    def os_total(os_data)
      os_data.map { |row| row['count'] }.reduce(0, :+)
    end

    def major_version_sort(data)
      data.sort_by do |row|
        version = row['version']
        number = version.match('([0-9.]+)').captures[0]
        Gem::Version.new(number)
      end.reverse
    end

    def self.tip(section)
      tips = {
        :os_version => "This data can now be found in the Audiences section of Firebase Analytics. Before you export the CSV file, change one of the charts to `Users` by `OS with version`",
        :gender_age => "Note: The columns for Gender+Age are not always in the same order, but this is taken into account when searching",
        :devices => "Note: If you export from the Tech Details: Device Model page, this is currently unsupported as it has two different headers. Use the export from the main Dashboard page"
      }
      tips[section]
    end
  end
end
