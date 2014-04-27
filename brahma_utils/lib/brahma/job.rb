module Brahma
  class JobSender
    def initialize(name, redis)
      @redis = redis
      @name = name
    end

    def echo(message)
      send({type: :echo, message: message})
    end

    def email(to, subject, content)
      send({type: :email, to: to, subject: subject, content: content, create: Time.now, timeout: 60*60*24})
    end

    def send(request={})
      @redis.with do |conn|
        conn.lpush queue, Marshal.dump(request)
      end
    end


    def receive(timeout)
      @redis.with do |conn|
        task = conn.brpop(queue, timeout)
        unless task.nil?
          yield Marshal.load(task[1])
        end
      end
    end

    private
    def queue
      "worker://#{@name}"
    end
  end
end