require 'bunny'

module Brahma
  module Job
    class RabbitJobSender
      #host='localhost', port='5672'
      def initialize(name, timeout, options)
        @conn = Bunny.new "amqp://#{options.fetch(:host)}:#{options.fetch(:port)}"
        @conn.start
        @conn.qos
        @name = name
        @timeout = timeout
      end

      def send(request)
        ch, q = queue @name
        x = ch.default_exchange
        x.publish request, routing_key: q.name
      end

      def receive
        q = queue(@name)[1]
        q.subscribe(ack: true, timeout: @timeout) do |_, _, payload|
          yield payload
        end
        q.ack
      end

      def close
        @conn.stop
      end

      private
      def queue(name)
        ch = conn.channel
        q = ch.queue name
        [ch, q]
      end

    end

  end
end