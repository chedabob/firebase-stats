module FirebaseStats
  # Parses the Firebase CSV file into sections
  class DeviceUtils
    # Is this device name an iOS device?
    # @param [CSV::Row] device_name
    def self.ios_device?(device_name)
      device_name.downcase.include?('iphone') or device_name.downcase.include?('ipad') or device_name.downcase.include?('ipod')
    end

    # Filters a device list to only the requested platform
    # @param [CSV::Table] device_data
    # @param [Symbol] platform One of :all, :ios, :android
    def self.filter_device(device_data, platform)
      case platform
      when :android
        device_data.reject { |row| ios_device? row['Device model'] }
      when :ios
        device_data.select { |row| ios_device? row['Device model'] }
      else
        device_data
      end
    end
  end
end
