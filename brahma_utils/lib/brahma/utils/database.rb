require 'sequel'
require_relative 'logger'

module Brahma::Utils

  #adapter::mysql2 username password host port socket database
  #adapter::sqlite3 path
  module Database
    LOGGER=Logger.instance.create 'database'

    module_function

    def connect(options)
      case options.fetch(:adapter)
        when :mysql2
          require 'mysql2'
          options[:user] = options.delete :username
          Sequel.connect(options)
        when :sqlite3
          require 'sqlite3'
          Sequel.connect "sqlite://#{options.fetch :path}"
        else
          fail "不支持的数据库#{adapter}"
      end
    end

    def create(options)
      case options.fetch(:adapter)
        when :mysql2
          require 'mysql2'
          database = options.delete :database
          conn = Mysql2::Client.new options
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