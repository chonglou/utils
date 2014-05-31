require 'singleton'

module Brahma

  class Factory
    include Singleton
    attr_reader :encryptor, :mysql, :jobber

    def setup!(root, env)
      @root = root
      @env = env
    end

    def load_mysql
      require 'brahma/config/mysql'
      require 'brahma/utils/database'
      @mysql = Brahma::Utils::Database.connect load_cfg('database')
    end

    def load_jobber
      require 'brahma/config/jobber'
      cfg = load_cfg('jobber')
      type = cfg.delete :type
      require "brahma/job/#{type}_sender"
      @jobber = Brahma::Job.const_get("#{type.capitalize}Sender").new cfg
    end

    def load_encryptor
      require 'brahma/config/keys'
      cfg = load_cfg 'keys'
      @encryptor = Brahma::Utils::Encryptor.new cfg.fetch(:key), cfg.fetch(:iv)
    end

    def load_cfg(name)
      Brahma::Config.const_get(name.capitalize).new("#{@root}/config/#{name}.yml").load(@env)
    end
  end

end