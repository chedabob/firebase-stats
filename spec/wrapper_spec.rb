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
end
