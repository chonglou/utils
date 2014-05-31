require 'redis'

module Brahma
  module Job

    class RedisSender
      #path='/var/run/redis/redis.sock', host='localhost', port=6379, db=0
      def initialize(name, timeout, options)
        @redis =Redis.new options
        @redis.ping
        @name = name
        @timeout = timeout
      end

      def send(request)
        @redis.lpush queue(@name), Marshal.dump(request)
      end


      def receive
        task = @redis.brpop(queue(@name), @timeout)
        unless task.nil?
          yield Marshal.load(task[1])
        end
      end

      def close

      end

      private
      def queue(name)
        "worker://#{name}"
      end
    end
  end
end