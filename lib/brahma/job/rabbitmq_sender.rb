require 'bunny'

module Brahma
  module Job
    class RabbitJobSender
      #host='localhost', port='5672'
      def initialize(options)
        @conn = Bunny.new "amqp://#{options.fetch(:host)}:#{options.fetch(:port)}"
        @conn.start
        @conn.qos
      end

      def send(name, request)
        ch, q = queue name
        x = ch.default_exchange
        x.publish request, routing_key:q.name
      end

      def receive(name, timeout=5)
        q = queue( name)[1]
        q.subscribe(ack:true, timeout:timeout) do |_, _, payload|
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