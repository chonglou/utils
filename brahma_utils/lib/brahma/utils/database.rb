require 'sequel'
require_relative 'logger'

module Brahma
  module Database
    LOGGER=Brahma::Logger.instance.create 'database'

    module_function

    def connect(adapter: :mysql2, host: 'localhost', port: 3306, database: 'brahma', username: 'root', password: nil, pool: 10, ** options)
      case adapter
        when :mysql2
          require 'mysql2'
          Sequel.connect(:adapter => 'mysql2',
                         :host => host, :database => database, :port => port,
                         :user => username, :password => password,
                         :max_connections => pool, :logger => LOGGER)
        when :sqlite3
          require 'sqlite3'
          Sequel.connect "sqlite://#{options.fetch :path}"
        else
          fail "不支持的数据库#{adapter}"
      end
    end

    def create(adapter: :mysql2, host: 'localhost', port: 3306, database: 'brahma', username: 'root', password: nil, ** options)
      case adapter
        when :mysql2
          require 'mysql2'
          conn = Mysql2::Client.new(:host => host, :username => username, :password => password, :port => port)
          sql = "CREATE DATABASE IF NOT EXISTS #{database} DEFAULT CHARACTER SET 'utf8'"
          LOGGER.debug sql
          conn.query sql
          conn.close
        when :sqlite3
        else
          LOGGER.error "暂未支持数据库[#{adapter}]的自动创建"
      end
    end
  end
end