require_relative '_store'
require_relative '../utils/redis'

module Brahma::Config
  class Redis < Storage
    def load(env)
      if ENVIRONMENTS.include?(env)
        cfg = read.fetch(env)
        rv = {
            db: cfg.fetch('db'),
            pool: cfg.fetch('pool')
        }
        if cfg.has_key?('path')
          rv[:path] = cfg.fetch 'path'
        else
          rv[:host] = cfg.fetch 'host'
          rv[:port] = cfg.fetch 'port'
        end
        rv
      end
    end

    def setup!
      p_s '配置REDIS'
      redis = {}
      if ask('使用socket？(y/n)') { |q| q.default='n' } == 'y'
        redis['path'] = '/var/run/redis/redis.sock'
      else
        redis['host']=ask('主机： ') { |q| q.default='localhost' }.to_s
        redis['port']=ask('端口： ', Integer) do |q|
          q.default=6379
          q.in = 1..65536
        end
      end
      redis['db']=ask('数据库名： ', Integer) do |q|
        q.default=0
        q.in = 0...16
      end
      redis['pool'] = ask('连接池: ', Integer) do |q|
        q.default=4
        q.in=4...20
      end

      p_s '检查REDIS'
      data = {}
      ENVIRONMENTS.each do |env|
        r = redis.clone
        conn = {db: r.fetch('db'), pool:1}
        if r.has_key?('path')
          conn[:path]= r.fetch('path')
        else
          conn[:host]= r.fetch('host')
          conn[:port]= r.fetch('port')
        end
        Brahma::Utils::Redis::pool(conn).ping
        data[env] = r
      end

      p_s '检查完毕，刷新配置文件'
      write data
    end
  end
end
