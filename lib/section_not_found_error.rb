module FirebaseStats
  class SectionNotFoundError < StandardError
    attr_reader :section

    def initialize(section)
      @section = section
    end
  end
end