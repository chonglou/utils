require 'date'
module Brahma::Utils
  module TimeHelper
    module_function

    def month_r(year, month)
      [DateTime.new(year, month, 1),DateTime.new(year, month, -1)]
    end

    def day_r(year, month, day)
      [DateTime.new(year, month, day), DateTime.new(year, month, day, 24)]
      start= DateTime.new(year, month, day)
      [start, (start.to_time+100*60*60*24)]
    end

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