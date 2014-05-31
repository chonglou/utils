require 'bunny'

module Brahma
  module Job
    class RabbitMQ
      #host='localhost', port='5672'
      def initialize(name, timeout, options)
        @conn = Bunny.new "amqp://#{options.fetch(:host)}:#{options.fetch(:port)}"
        @conn.start
        @timeout = timeout

        ch = @conn.channel
        ch.prefetch 1
        @queue =ch.queue name
      end

      def send(request)
        @queue.publish request
      end

      def receive
        _, _, payload = @queue.pop
        if payload
          yield payload
        else
          sleep @timeout
        end
      end

      def close
        @conn.stop
      end


    end

  end
end