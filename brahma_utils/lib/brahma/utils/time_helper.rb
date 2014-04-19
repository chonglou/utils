require 'date'
module Brahma::Utils
  module TimeHelper
    module_function

    def next_day(clock)
      (Date.today+1).to_time+60*60*clock
    end

    def max
      Time.gm(9999, 12, 31, 23, 59, 59)
    end

    def min
      Time.gm(0)
    end
  end
end