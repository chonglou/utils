require 'redis'

module Brahma
  module Job

    class RedisSender
      #path='/var/run/redis/redis.sock', host='localhost', port=6379, db=0
      def initialize(options)
        @redis = Redis.new options
        @redis.ping
      end

      def send(name, request)
        @redis.with do |conn|
          conn.lpush queue(name), Marshal.dump(request)
        end
      end


      def receive(timeout)
        @redis.with do |conn|
          task = conn.brpop(queue(name), timeout)
          unless task.nil?
            yield Marshal.load(task[1])
          end
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