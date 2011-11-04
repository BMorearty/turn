module Turn

  #
  class TestSuite

    include Enumerable

    attr_accessor :name
    attr_accessor :size
    attr_accessor :cases
    attr_accessor :run_options

    # This one can be set manually since it
    # is not calculatable (beyond the case level).
    attr_accessor :count_assertions

    #
    def initialize(name=nil)
      @name  = name
      @size  = nil
      @cases = []
      @run_options = ''
    end

    #
    def new_case(name, *files)
      c = TestCase.new(name, *files)
      @cases << c
      c
    end

    def count_tests
      sum = 0; each{ |c| sum += c.count_tests }; sum
    end

    def count_assertions
      sum = 0; each{ |c| sum += c.count_assertions }; sum
    end

    def count_failures
      sum = 0; each{ |c| sum += c.count_failures }; sum
    end

    def count_errors
      sum = 0; each{ |c| sum += c.count_errors }; sum
    end

    def count_passes
      sum = 0; each{ |c| sum += c.count_passes }; sum
    end

    def count_skips
      sum = 0; each{ |c| sum += c.count_skips }; sum
    end

    # Convenience methods --this is what is typcially wanted.
    def counts
      return count_tests, count_assertions, count_failures, count_errors,count_skips
    end

    def each(&block)
      @cases.each(&block)
    end

    def size
      @size ||= @cases.size
    end

    def passed?
      (count_failures == 0 && count_errors == 0)
    end
  end

end

