require_relative '_store'
require_relative '../utils/redis'
require_relative '../utils/string_helper'

module Brahma::Config
  class Jobber < Storage
    TYPES = %w(redis rabbitmq)

    def load(env)
      if ENVIRONMENTS.include?(env)
        cfg = read.fetch(env)
        type = cfg.fetch('type')
        if TYPES.include?(type)
          rv = send "read_#{type}", cfg
          rv[:name]= cfg.fetch('name')
          rv[:timeout]= cfg.fetch('timeout')
          rv[:type]= cfg.fetch('type')
          rv
        else
          fail '不支持的类型'
        end
      end
    end

    def setup!
      p_s '配置任务系统'
      type = ask('类型？(redis/rabbitmq)')
      if TYPES.include?(type)
        cfg = send "ask_#{type}"
        cfg['timeout'] = ask('超时？(秒)', Integer) do |q|
          q.default=5
          q.in = 2..300
        end
        cfg['type'] = type

        data = {}
        ENVIRONMENTS.each do |env|
          r = cfg.clone
          r['name'] = Brahma::Utils::StringHelper.uuid
          data[env] = r
        end
        p_s '刷新配置文件'
        write data
      else
        p_s '错误的类型'
      end
    end

    private
    def ask_redis
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
      redis['db']=ask('数据库： ', Integer) do |q|
        q.default=0
        q.in = 0...16
      end
      redis
    end

    def ask_rabbitmq
      p_s '配置RabbitMQ'
      mq = {}
      mq['host']=ask('主机： ') { |q| q.default='localhost' }.to_s
      mq['port']=ask('端口： ', Integer) do |q|
        q.default=5672
        q.in = 1..65536
      end

      mq
    end

    def read_redis(cfg)
      rv = {
          db: cfg.fetch('db')
      }
      if cfg.has_key?('path')
        rv[:path] = cfg.fetch 'path'
      else
        rv[:host] = cfg.fetch 'host'
        rv[:port] = cfg.fetch 'port'
      end
      rv
    end

    def read_rabbitmq(cfg)
      {
          host: cfg.fetch('host'),
          port: cfg.fetch('port'),
      }
    end
  end
end
