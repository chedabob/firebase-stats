module FirebaseStats
  class DataError < StandardError
    attr_reader :section, :expected_header, :tip

    def initialize(section, expected_header, tip = nil)
      @section = section
      @expected_header = expected_header
      @tip = tip
    end
  end
end