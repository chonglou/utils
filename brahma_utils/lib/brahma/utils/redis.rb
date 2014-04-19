require 'redis'
require 'connection_pool'

module Brahma::Utils
  module Redis
    module_function

    def pool(host: 'localhost', port: 6379, db: 'brahma', pool: 4, ** options)
      ConnectionPool::Wrapper.new(size: pool, timeout: 3) {
        ::Redis.new host: host, port: port, db: db
      }
    end
  end
end