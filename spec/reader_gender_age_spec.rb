# frozen_string_literal: true

RSpec.describe FirebaseStats::Reader do
  before(:each) do
    @stats = FirebaseStats::Reader.new
  end
  describe 'parse file with gender+age data' do

    it 'parses the old gender age data' do
      @stats.parse_file 'spec/test_csv/old_gender_age.csv'
      gender_age = @stats.get(:gender_age)
      expect(gender_age).not_to be_nil
      expect(gender_age.length).to eq(4)
    end

    it 'parses the alternative old gender age data' do
      @stats.parse_file 'spec/test_csv/old_gender_age_alt.csv'
      gender_age = @stats.get(:gender_age)
      expect(gender_age).not_to be_nil
      expect(gender_age.length).to eq(4)
    end


    it 'parses the new gender age data' do
      @stats.parse_file 'spec/test_csv/new_gender_age.csv'
      gender_age = @stats.get(:gender_age)
      expect(gender_age).not_to be_nil
      expect(gender_age.length).to eq(7)
    end
  end
end
