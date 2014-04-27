module Brahma
  class JobSender
    def initialize(name, redis)
      @redis = redis
      @name = name
    end

    def echo(message)
      send mq, {type: :echo, message: message}
    end

    def email(to, subject, content)
      send mq, {type: :email, to: to, subject: subject, content: content, create: Time.now, timeout: 60*60*24}
    end

    def send(queue, request={})
      @redis.with do |conn|
        conn.lpush queue, Marshal.dump(request)
      end
    end

    private
    def mq
      "worker://#{@name}"
    end
  end
end