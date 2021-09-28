# frozen_string_literal: true

RSpec.describe FirebaseStats::Reader do
  before(:each) do
    @stats = FirebaseStats::Reader.new
  end
  describe 'parse single file with header' do
    before(:each) do
      path = 'spec/test_csv/single_withfileheader.csv'
      @stats.parse_file path
    end
    it 'parses the active users' do
      active_users = @stats.data[:active_users]
      expect(active_users).not_to be_nil
      expect(active_users.length).to eq(90)
    end

    it 'has correct first row' do
      active_users = @stats.data[:active_users]
      first_row = active_users[0]
      expect(first_row['Day']).to eq('0000')
      expect(first_row['28-Day']).to eq('214')
      expect(first_row['7-Day']).to eq('69')
      expect(first_row['1-Day']).to eq('19')
    end

    it 'has correct last row' do
      active_users = @stats.data[:active_users]
      last_row = active_users[89]
      expect(last_row['Day']).to eq('0089')
      expect(last_row['28-Day']).to eq('211')
      expect(last_row['7-Day']).to eq('64')
      expect(last_row['1-Day']).to eq('85')
    end
  end

  describe 'parse two section file with header' do
    before(:each) do
      path = 'spec/test_csv/twosection.csv'
      @stats.parse_file path
    end
    it 'has two sections' do
      expect(@stats.data.length).to eq(2)
    end

    it 'has correct first row of active users' do
      active_users = @stats.data[:active_users]
      first_row = active_users[0]
      expect(first_row['Day']).to eq('0000')
      expect(first_row['28-Day']).to eq('2569')
      expect(first_row['7-Day']).to eq('741')
      expect(first_row['1-Day']).to eq('139')
    end

    it 'has correct last row of active users' do
      active_users = @stats.data[:active_users]
      last_row = active_users[89]
      expect(last_row['Day']).to eq('0089')
      expect(last_row['28-Day']).to eq('3301')
      expect(last_row['7-Day']).to eq('968')
      expect(last_row['1-Day']).to eq('168')
    end

    it 'has correct first row of daily engagement' do
      daily_engagement = @stats.data[:daily_engagement]
      first_row = daily_engagement[0]
      expect(first_row['Day']).to eq('0000')
      expect(first_row['Average engagement time']).to eq('128.46043165467626')
    end

    it 'has correct last row of daily engagement' do
      daily_engagement = @stats.data[:daily_engagement]
      last_row = daily_engagement[89]
      expect(last_row['Day']).to eq('0089')
      expect(last_row['Average engagement time']).to eq('158.41666666666666')
    end
  end

  describe 'parse app2' do
    before(:each) do
      path = 'spec/test_csv/app2.csv'
      @stats.parse_file path
    end
    it 'parses all the sections' do
      expect(@stats.data.length).to eq(15)
    end
    it 'parses the active users' do
      active_users = @stats.data[:active_users]
      expect(active_users).not_to be_nil
      expect(active_users.length).to eq(90)
    end

    it 'parses the daily engagement' do
      daily_engagement = @stats.data[:daily_engagement]
      expect(daily_engagement).not_to be_nil
      expect(daily_engagement.length).to eq(90)
    end

    it 'parses the active screens' do
      active_screens = @stats.data[:screens]
      expect(active_screens).not_to be_nil
      expect(active_screens.length).to eq(3)
    end

    it 'parses the revenue' do
      revenue = @stats.data[:revenue]
      expect(revenue).not_to be_nil
      expect(revenue.length).to eq(0)
    end

    it 'parses the crash free users' do
      crash_free_users = @stats.data[:crash_free_users]
      expect(crash_free_users).not_to be_nil
      expect(crash_free_users.length).to eq(4)
    end

    it 'parses the version adoption' do
      version_adoption = @stats.data[:version_adoption]
      expect(version_adoption).not_to be_nil
      expect(version_adoption.length).to eq(3)
    end

    it 'parses the acquisition' do
      acquisition = @stats.data[:acquisition]
      expect(acquisition).not_to be_nil
      expect(acquisition.length).to eq(5)
    end

    it 'parses the retention cohorts' do
      retention_cohorts = @stats.data[:retention_cohorts]
      expect(retention_cohorts).not_to be_nil
      expect(retention_cohorts.length).to eq(6)
    end

    it 'parses the audience country' do
      audience_country = @stats.data[:audience_country]
      expect(audience_country).not_to be_nil
      expect(audience_country.length).to eq(193)
    end

    it 'parses the devices' do
      devices = @stats.data[:devices]
      expect(devices).not_to be_nil
      expect(devices.length).to eq(2722)
    end

    it 'parses the os version' do
      os_version = @stats.data[:os_version]
      expect(os_version).not_to be_nil
      expect(os_version.length).to eq(115)
    end

    it 'parses the gender' do
      gender = @stats.data[:gender]
      expect(gender).not_to be_nil
      expect(gender.length).to eq(2)
    end

    it 'parses the gender age' do
      gender_age = @stats.data[:gender_age]
      expect(gender_age).not_to be_nil
      expect(gender_age.length).to eq(6)
    end

    it 'parses the platform' do
      platform = @stats.data[:platform]
      expect(platform).not_to be_nil
      expect(platform.length).to eq(2)
      expect(platform[0]['Users']).to eq('907909')
      expect(platform[1]['Users']).to eq('874454')
    end

    it 'parses the platform engagement' do
      platform_engagement = @stats.data[:platform_engagement]
      expect(platform_engagement).not_to be_nil
      expect(platform_engagement.length).to eq(2)
      expect(platform_engagement[0]['% Total']).to eq('0.5093850130416756')
      expect(platform_engagement[1]['% Total']).to eq('0.49061498695832445')
      expect(platform_engagement[0]['User engagement']).to eq('81.9344448501075')
      expect(platform_engagement[1]['User engagement']).to eq('70.1780268220262')
    end
  end

  describe 'parse app1' do
    before(:each) do
      path = 'spec/test_csv/app1.csv'
      @stats.parse_file path
    end
    it 'parses all sections' do
      expect(@stats.data).not_to be_nil
      expect(@stats.data.length).to eq(15)
    end
  end

  describe 'parse app3' do
    before(:each) do
      path = 'spec/test_csv/app3.csv'
      @stats.parse_file path
    end
    it 'parses all sections' do
      expect(@stats.data).not_to be_nil
      expect(@stats.data.length).to eq(14)
    end
  end

  describe 'parse app4' do
    before(:each) do
      path = 'spec/test_csv/app4.csv'
      @stats.parse_file path
    end
    it 'parses all sections' do
      expect(@stats.data).not_to be_nil
      expect(@stats.data.length).to eq(15)
    end
  end

  describe 'parse app5' do
    before(:each) do
      path = 'spec/test_csv/app5.csv'
      @stats.parse_file path
    end
    it 'parses all sections' do
      expect(@stats.data).not_to be_nil
      expect(@stats.data.length).to eq(15)
    end
  end
end
