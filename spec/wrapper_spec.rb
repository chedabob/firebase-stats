# frozen_string_literal: true

RSpec.describe FirebaseStats::Wrapper do
  before(:each) do
    @stats = FirebaseStats::Reader.new
    path = 'spec/test_csv/app2.csv'
    @stats.parse_file path
    @wrapper = FirebaseStats::Wrapper.new @stats
  end

  describe 'wrap OS versions' do
    it 'returns all OS data' do
      versions = @wrapper.os
      expect(versions).not_to be_nil
    end
  end

  describe 'wrap Gender' do
    it 'returns all Gender data' do
      gender = @wrapper.gender
      expect(gender).not_to be_nil
      expect(gender.count).to eq(2)
      female = gender.select { |row| row['gender'] == 'female'}[0]
      male = gender.select { |row| row['gender'] == 'male'}[0]

      expect(female['count']).to eq(395692)
      expect(male['count']).to eq(348442)
    end
  end

  describe 'wrap Gender Age' do
    it 'returns 2 gender groups in old data format' do
      @stats.parse_file 'spec/test_csv/old_gender_age.csv'
      @wrapper = FirebaseStats::Wrapper.new @stats

      gender_age = @wrapper.gender_age
      expect(gender_age).not_to be_nil
      first_row = gender_age[0]
      expect(first_row).not_to be_nil
      expect(first_row['male']).not_to be_nil
      expect(first_row['female']).not_to be_nil
    end

    it 'returns 2 gender groups in alternate old data format' do
      @stats.parse_file 'spec/test_csv/old_gender_age_alt.csv'
      @wrapper = FirebaseStats::Wrapper.new @stats

      gender_age = @wrapper.gender_age
      expect(gender_age).not_to be_nil
      first_row = gender_age[0]
      expect(first_row).not_to be_nil
      expect(first_row['male']).not_to be_nil
      expect(first_row['female']).not_to be_nil
    end

    it 'returns 3 gender groups in new data format' do
      @stats.parse_file 'spec/test_csv/new_gender_age.csv'
      @wrapper = FirebaseStats::Wrapper.new @stats

      gender_age = @wrapper.gender_age
      expect(gender_age).not_to be_nil
      first_row = gender_age[0]
      expect(first_row).not_to be_nil
      expect(first_row['male']).not_to be_nil
      expect(first_row['female']).not_to be_nil
      expect(first_row['other']).not_to be_nil
    end
  end

  describe 'provide error' do
    it 'throws error when no OS data found' do
      @stats.parse_file 'spec/test_csv/empty.csv'
      @wrapper = FirebaseStats::Wrapper.new @stats

      expect { @wrapper.os }.to raise_error FirebaseStats::DataError
    end
  end
end
