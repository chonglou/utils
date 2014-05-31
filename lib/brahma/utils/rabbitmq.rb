require 'bunny'

module Brahma
  module Utils
    class RabbitMQ
      def initialize(host, port=5672)
        @conn = Bunny.new "amqp://#{host}:#{port}"
        @conn.start
      end

      def channel
        @conn.create_channel
      end

      def close
        @conn.stop
      end

    end
  end
end
