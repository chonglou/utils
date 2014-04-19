require_relative '_store'
require_relative '../utils/redis'

module Brahma::Config
  class Mysql < Storage
    def load
      if ENVIRONMENTS.include?(env)
        cfg = read.fetch(env)
        {
            host: cfg.fetch('host'),
            port: cfg.fetch('port'),
            db: cfg.fetch('db'),
            pool: cfg.fetch('pool')
        }
      end
    end
    def setup!
      p_s '配置REDIS'
      redis = {}
      redis[:host]=ask('主机： ') { |q| q.default='localhost' }.to_s
      redis[:port]=ask('端口： ', Integer) do |q|
        q.default=6379
        q.in = 1..65536
      end
      redis[:db]=ask('数据库名： ') { |q| q.default='brahma' }.to_s
      redis[:pool] = ask('连接池: ', Integer) do |q|
        q.default=4
        q.in=4...20
      end

      p_s '检查REDIS'
      data = {}
      ENVIRONMENTS.each do |env|
        r = redis.clone
        r[:db] = "#{redis.fetch :db}_#{env[0]}"
        Brahma::Utils::Redis::pool(r).ping
        data[env] = r
      end

      p_s '检查完毕，刷新配置文件'
      write data
    end
  end
end
