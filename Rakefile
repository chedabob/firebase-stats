# frozen_string_literal: true
require 'net/http'
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task default: :spec

  task :update_device_mapping do
    download_url = 'https://raw.githubusercontent.com/pbakondy/android-device-list/master/devices.json'
    save_location = './lib/devices.json'

    uri = URI(download_url)
    contents = Net::HTTP.get(uri)

    File.open(save_location, 'wb') do |file|
      file.write(contents)
    end
  end

rescue LoadError
  # no rspec available
end
