# frozen_string_literal: true

class FirebaseStats
  require 'csv'
  require 'android/devices'
  require 'open-uri'

  # Transforms the parsed Firebase file into something more user friendly
  class Wrapper
    # @param [FirebaseStats::Reader] stats
    # @param [Symbol] platform One of :all, :ios, :android
    def initialize(stats, platform = :all)
      super()
      @stats = stats
      @platform = platform
    end

    def os_version
      filtered = filter_os(@stats.data[:os_version], @platform)

      cleaned = []
      filtered.each do |row|
        cleaned << {
          'version' => row['OS with version'],
          'count' => row['Users'].to_i,
          'percentage' => as_percentage(os_total, row['Users'].to_f)
        }
      end
      cleaned
    end

    def os_grouped
      raw_os = @stats.data[:os_version]

      grouped = case @platform
                when :ios
                  ios_os_group(raw_os)
                when :android
                  android_os_group(raw_os)
                else
                  android_os_group(raw_os).merge ios_os_group(raw_os)
                end
      computed = []
      grouped.each do |k, v|
        version_name = k
        total = v.map { |version| version['Users'].to_i }.reduce(0, :+)
        computed << { 'version' => version_name, 'total' => total, 'percentage' => as_percentage(os_total, total.to_f) }
      end
      computed
    end

    def os_total
      filtered = filter_os(@stats.data[:os_version], @platform)
      total = 0
      filtered.each do |row|
        total += row['Users'].to_i
      end
      total
    end

    def devices(friendly: false, limit: 10)
      filtered = filter_device(@stats.data[:devices], @platform)
      filtered = filtered.take(limit || 10)
      cleaned = []
      filtered.each do |row|
        device = {
          'model' => row['Device model']
        }
        if friendly && ((@platform == :all) || (@platform == :android))
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
      raw = @stats.data[:gender]
      data = []
      raw.each do |row|
        data << {
          'gender' => row['Gender'],
          'count' => row['Users']
        }
      end
      data
    end

    def gender_age
      raw = @stats.data[:gender_age]
      data = []
      raw.each do |row|
        data << {
          'age' => row['Category'],
          'male' => (row['Male'].to_f * 100).round(2),
          'female' => (row['Female'].to_f * 100).round(2)
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
        os_data.select { |row| row['OS with version'].downcase.include?('android') }
      when :ios
        os_data.select { |row| row['OS with version'].downcase.include?('ios') }
      else
        os_data
      end
    end

    # @param [CSV::Table] device_data
    # @param [Symbol] platform One of :all, :ios, :android
    def filter_device(device_data, platform)
      case platform
      when :android
        device_data.reject { |row| ios_device? row['Device model'] }
      when :ios
        device_data.select { |row| ios_device? row['Device model'] }
      else
        device_data
      end
    end

    # @param [CSV::Row] device_name
    def ios_device?(device_name)
      device_name.downcase.include?('iphone') or device_name.downcase.include?('ipad') or device_name.downcase.include?('ipod')
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
      filter_os(os_details, :ios).group_by { |row| row['OS with version'].match('(iOS [0-9]{1,2})').captures[0] }
    end

    def android_os_group(os_details)
      filter_os(os_details, :android).group_by { |row| row['OS with version'].match('(Android [0-9]{1,2})').captures[0] }
    end
  end
end
