require_relative '_store'
require_relative '../utils/database'

module Brahma::Config
  class Mysql < Storage
    def load
      if ENVIRONMENTS.include?(env)
        cfg = read.fetch(env)
        {
            host: cfg.fetch('host'),
            port: cfg.fetch('port'),
            database: cfg.fetch('database'),
            username: cfg.fetch('username'),
            password: cfg.fetch('password'),
            pool: cfg.fetch('pool')
        }
      end
    end

    def setup!
      p_s 'MYSQL设置'
      mysql = {}
      mysql['host']=ask('主机： ') { |q| q.default='localhost' }.to_s
      mysql['port']=ask('端口： ', Integer) do |q|
        q.default=3306
        q.in = 1..65536
      end
      mysql['database']=ask('数据库名： ') { |q| q.default='brahma' }.to_s
      mysql['username']=ask('用户名： ') { |q| q.default='root' }.to_s
      mysql['password']=ask('输入密码： ') { |q| q.echo='x' }.to_s
      mysql['pool'] = ask('连接池: ', Integer) do |q|
        q.default=10
        q.in=4...20
      end

      p_s '检查MYSQL数据库'
      data = {}
      ENVIRONMENTS.each do |env|
        m = mysql.clone
        m['database'] = "#{m.fetch 'database'}_#{env[0]}"
        Brahma::Utils::Database.create m
        Brahma::Utils::Database.connect m
        m['adapter']='mysql2'
        m['encoding']='utf8'
        m['timeout']=5000
        data[env] = m
      end

      p_s '检查完毕，刷新配置文件'
      write data
    end
  end
end