require_relative '../lib/brahma/utils/rabbitmq'

describe 'RabbmitMQ' do
  it '发消息' do
    mq = Brahma::Utils::RabbitMQ.new 'localhost'
    ch = mq.channel
    q = ch.queue 'test', auto_delete: true
    x = ch.default_exchange

    q.subscribe do |_, _, payload|
      puts "收到, #{payload}"
    end

    x.publish "Hello, #{Time.now}", routing_key:q.name
    sleep 1
    mq.close

  end
end