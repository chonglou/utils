require 'redis'
require 'connection_pool'

module Brahma::Utils
  module Redis
    module_function

    #host port db pool path
    def pool(options)
      ConnectionPool::Wrapper.new(size: options.fetch(:pool), timeout: 3) {
        options.delete :pool
        ::Redis.new options
      }
    end
  end
end