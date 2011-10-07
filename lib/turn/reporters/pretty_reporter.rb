require 'turn/reporter'

module Turn

  # = Pretty Reporter (by Paydro)
  #
  class PrettyReporter < Reporter
    PADDING_SIZE = 4

    def start_suite(suite)
      @suite  = suite
      @time   = Time.now
      io.puts "Loaded suite #{suite.name}"
      io.puts "Started"
    end

    def start_case(kase)
      @case_header = "\n#{kase.name}:\n"
    end

    def print_case_header
      io.print @case_header
      @case_header = nil
    end

    def start_test(test)
      print_case_header
      @test_time = Time.now
      @test_name = format_name(test.name)
    end

    def pass(message=nil)
      io.print pad_with_size("#{PASS}")
      io.print " #{@test_name}"
      io.print " (%.2fs) " % (Time.now - @test_time)
      if message
        message = Colorize.magenta(message)
        message = message.to_s.tabto(10)
        io.puts(message)
      end
    end

    def fail(assertion)
      io.print pad_with_size("#{FAIL}")
      io.print " #{@test_name}"
      io.print " (%.2fs) " % (Time.now - @test_time)

      message = assertion.message

      _trace = if assertion.respond_to?(:backtrace)
                 filter_backtrace(assertion.backtrace)
               else
                 filter_backtrace(assertion.location).first
               end
      io.puts
      tabsize = 10
      io.puts message.tabto(tabsize)
      io.puts _trace.shift.tabto(tabsize)
      if @trace
        io.puts _trace.map{|l| l.tabto(tabsize) }.join("\n")
      end
    end

    def error(exception)
      io.print pad_with_size("#{ERROR}")
      io.print " #{@test_name}"
      io.print " (%.2fs) " % (Time.now - @test_time)

      message = exception.message

      _trace = if exception.respond_to?(:backtrace)
                 filter_backtrace(exception.backtrace)
               else
                 filter_backtrace(exception.location)
               end
      trace = _trace.shift
      io.puts
      tabsize = 10
      io.puts message.tabto(tabsize)
      io.puts trace.tabto(tabsize)
      if @trace
        io.puts _trace.map{|l| l.tabto(tabsize) }.join("\n")
      end
    end

    # TODO: skip support
    #def skip
    #  io.puts(pad_with_size("#{SKIP}"))
    #end

    def finish_test(test)
      io.puts
    end

    def finish_case(kase)
    end

    def finish_suite(suite)
      total   = suite.count_tests
      failure = suite.count_failures
      error   = suite.count_errors
      #pass    = total - failure - error

      io.puts
      io.puts "Finished in #{'%.6f' % (Time.now - @time)} seconds."
      io.puts

      io.print "%d tests, " % total
      io.print "%d assertions, " % suite.count_assertions
      io.print Colorize.fail( "%d failures" % failure) + ', '
      io.print Colorize.error("%d errors" % error) #+ ', '
      #io.puts  Colorize.cyan( "%d skips" % skips ) #TODO
      io.puts
    end

  private

    def pad(str, size=PADDING_SIZE)
      " " * size + str
    end

    def pad_with_size(str)
      " " * (18 - str.size) + str
    end

  end

end

