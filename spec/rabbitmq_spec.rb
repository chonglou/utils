require 'brahma/utils/rabbitmq'
require 'brahma/job/rabbit_mq'

describe 'RabbmitMQ' do
  it '任务' do
    mq = Brahma::Job::RabbitMQ.new('test1', 5, host:'localhost', port:5672)

    mq.receive do |line|
      puts "receive #{line}"
    end
    mq.send "Hi, #{Time.now}"
    mq.close
  end

  # it '发消息' do
  #   mq = Brahma::Utils::RabbitMQ.new 'localhost'
  #   ch = mq.channel
  #   q = ch.queue 'test2', auto_delete: true
  #   x = ch.default_exchange
  #
  #   q.subscribe do |_, _, payload|
  #     puts "收到, #{payload}"
  #   end
  #
  #   x.publish "Hello, #{Time.now}", routing_key:q.name
  #   sleep 1
  #   mq.close
  #
  # end
end